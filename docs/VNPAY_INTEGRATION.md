# TÀI LIỆU TÍCH HỢP THANH TOÁN VNPAY SANDBOX (API v2.1.0)

## 1. Tổng quan kiến trúc & Luồng thanh toán

- Chuẩn tích hợp: **VNPay Payment Gateway API v2.1.0**, thuật toán chữ ký **HMAC-SHA512**.
- Kiến trúc dữ liệu:
  - `session` (1) — (0..1) `invoice` — (1) `payment` — (0..N) `paymenttransaction`.
  - Bảng `payment` giữ vai trò bản ghi thanh toán chính cho báo cáo và quy tắc đóng bàn (`Status = 1` mới cho phép đóng `session`).
  - Bảng `paymenttransaction` lưu lịch sử từng lần thử giao dịch VNPay với `VnpTxnRef` duy nhất (không ghi đè giao dịch cũ).
- Nguyên tắc toàn vẹn:
  - **Return URL** chỉ xác minh chữ ký để hiển thị kết quả, **không** chốt `PAID`.
  - **IPN** là luồng xác nhận chính thức, thực hiện trong MySQL Transaction (`SELECT ... FOR UPDATE`), đối chiếu số tiền bằng số nguyên `BigInt` (`VNĐ * 100`), chống lặp (idempotent) và chống thanh toán trùng (`DUPLICATE_CONFLICT` + `NeedReconcile = 1`).
  - Nếu IPN chậm, giao dịch giữ nguyên `PENDING` và có thể đối soát qua API **VNPay `querydr`**.

---

## 2. Cấu hình biến môi trường (`backend/.env`)

Xem mẫu tại `backend/.env.example`:

```env
VNP_TMN_CODE=YOUR_SANDBOX_TMN_CODE
VNP_HASH_SECRET=YOUR_SANDBOX_HASH_SECRET
VNP_URL=https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
VNP_API_URL=https://sandbox.vnpayment.vn/merchant_webapi/api/transaction
VNP_RETURN_URL=http://localhost:3000/api/payments/vnpay/return
VNP_IPN_URL=https://your-https-tunnel-or-cloud-domain/api/payments/vnpay/ipn
VNP_FRONTEND_RETURN_URL=http://localhost:5173/customer/payment-result
VNP_PENDING_TIMEOUT_MINUTES=15
```

- Đăng ký tài khoản Sandbox tại: https://sandbox.vnpayment.vn/devreg/
- **Bảo mật**: Không commit file `.env` hay secret thật lên GitHub. Không truyền `sessionToken` trên query string.

---

## 3. Triển khai Database Migration

Chạy file migration trước khi khởi động backend bản mới:

```bash
mysql -u root -p quanlynhahang < backend/sql/migrations/001_vnpay_payment_transaction.sql
```

File migration an toàn cho dữ liệu cũ, không xóa bảng `payment` và không tự động thay đổi schema khi backend khởi động.

---

## 4. Hướng dẫn cấu hình HTTPS Tunnel để nhận IPN khi chạy Local

Máy chủ VNPay Sandbox yêu cầu `vnp_IpnUrl` phải là địa chỉ **HTTPS** truy cập được từ Internet.

1. Khởi động Backend ở port `3000` (`npm run dev` trong `backend/`).
2. Mở một trong các công cụ tunnel:
   - **Cloudflare Tunnel**: `cloudflared tunnel --url http://localhost:3000`
   - **ngrok**: `ngrok http 3000`
3. Lấy domain HTTPS được cấp (ví dụ `https://abc-xyz.ngrok-free.app`), cập nhật:
   - Trên cổng quản trị VNPay Sandbox: cấu hình IPN URL là `https://abc-xyz.ngrok-free.app/api/payments/vnpay/ipn`.
   - Trong `backend/.env`: cập nhật `VNP_IPN_URL` tương ứng.
4. Trên môi trường Railway Cloud (`https://quanlynhahang-app-production.up.railway.app`), hệ thống đã có sẵn HTTPS nên dùng trực tiếp:
   - `VNP_RETURN_URL=https://quanlynhahang-app-production.up.railway.app/api/payments/vnpay/return`
   - `VNP_IPN_URL=https://quanlynhahang-app-production.up.railway.app/api/payments/vnpay/ipn`
   - `VNP_FRONTEND_RETURN_URL=https://quanlynhahang-app-production.up.railway.app/customer/payment-result`

---

## 5. Danh sách API thanh toán VNPay

| Method | Endpoint | Quyền | Mô tả |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/payments/customer/preview` | Khách (`sessionToken` trong body) | Xem chi tiết hóa đơn tạm tính từ DB |
| `POST` | `/api/payments/vnpay/create` | Khách (`sessionToken`) hoặc Thu ngân (JWT) | Tạo hóa đơn (nếu chưa có), tạo `PaymentTransaction` `PENDING`, trả `paymentUrl` |
| `GET` | `/api/payments/vnpay/return` | Public (VNPay redirect) | Verify chữ ký & redirect về `/customer/payment-result` |
| `GET` | `/api/payments/vnpay/ipn` | Public (VNPay server) | Verify 8 lớp, cập nhật DB trong Transaction, trả `{ RspCode, Message }` |
| `POST` | `/api/payments/vnpay/status` | Khách (`sessionToken`) hoặc Nhân viên (JWT) | Kiểm tra/poll trạng thái giao dịch |
| `POST` | `/api/payments/vnpay/querydr` | `Cashier`, `BranchManager`, `RestaurantAdmin` | Đối soát trạng thái thật từ VNPay khi IPN chậm |
| `GET` | `/api/payments/vnpay/transactions` | `Cashier`, `BranchManager`, `RestaurantAdmin` | Xem lịch sử giao dịch & danh sách `NeedReconcile = 1` |

---

## 6. Chạy kiểm thử tự động

```bash
cd backend
npm test
```
