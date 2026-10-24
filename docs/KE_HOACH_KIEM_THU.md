# KẾ HOẠCH KIỂM THỬ TOÀN DIỆN HỆ THỐNG QUẢN LÝ NHÀ HÀNG BBQ (E2E & ACTORS)

## 1. Mục tiêu và Phạm vi Kiểm thử

Kế hoạch này nhằm xác minh tính đúng đắn, liền mạch và thẩm quyền của tất cả **5 Actor** cùng toàn bộ các quy trình nghiệp vụ trong hệ thống theo tài liệu đặc tả:
1. **Khách hàng (Customer)**: Trải nghiệm đặt món qua QR, xem menu, giỏ hàng, đặt món, theo dõi trạng thái món, yêu cầu tính tiền.
2. **Nhân viên Phục vụ (Waiter)**: Sơ đồ bàn, xác nhận mở bàn (nhập số khách), tiếp nhận order, xác nhận chế biến, giao món.
3. **Thu ngân (Cashier)**: Quản lý bàn thanh toán, kiểm tra chi tiết hóa đơn, áp khuyến mãi, thanh toán (Tiền mặt/Chuyển khoản), phát hành hóa đơn và đóng bàn.
4. **Quản lý chi nhánh (BranchManager)**: Báo cáo doanh thu chi nhánh, quản lý bàn & QR, thực đơn chi nhánh (đè giá/ẩn món), nhân sự chi nhánh, cấu hình chi nhánh.
5. **Quản trị nhà hàng (RestaurantAdmin)**: Báo cáo toàn chuỗi, quản lý danh sách chi nhánh, thực đơn gốc & danh mục, chương trình khuyến mãi, nhân sự toàn chuỗi.

---

## 2. Danh sách Kịch bản & Quy trình Kiểm thử

### Giai đoạn 1: Chu trình Nghiệp vụ Cốt lõi End-to-End (E2E Flow)
Luồng nghiệp vụ thực tế diễn ra tại một bàn ăn:
- **Kịch bản E2E-01 (Customer)**: Khách hàng quét mã QR bàn `T1-01` (hoặc tạo phiên) $\rightarrow$ Hệ thống chuyển sang trạng thái chờ mở bàn.
- **Kịch bản E2E-02 (Waiter)**: Phục vụ đăng nhập tài khoản `waiter1` $\rightarrow$ Vào **Sơ đồ bàn** $\rightarrow$ Thấy bàn `T1-01` có trạng thái *Chờ mở bàn* $\rightarrow$ Xác nhận mở bàn với 4 khách $\rightarrow$ Bàn chuyển sang *Đang phục vụ*.
- **Kịch bản E2E-03 (Customer)**: Thiết bị khách hàng cập nhật phiên thành công $\rightarrow$ Xem thực đơn chi nhánh $\rightarrow$ Chọn món nướng, lẩu, đồ uống $\rightarrow$ Kiểm tra Giỏ hàng $\rightarrow$ Gửi Order.
- **Kịch bản E2E-04 (Waiter)**: Phục vụ vào màn hình **Gọi món & Chế biến** $\rightarrow$ Thấy order mới của bàn `T1-01` ở cột *Chờ xác nhận* $\rightarrow$ Xác nhận gửi bếp $\rightarrow$ Món chuyển sang *Đang chế biến* $\rightarrow$ Bấm xác nhận *Đã phục vụ* khi mang món ra bàn.
- **Kịch bản E2E-05 (Customer)**: Khách xem màn hình **Theo dõi món** (món đã chuyển trạng thái *Đã phục vụ*) $\rightarrow$ Xem hóa đơn tạm tính $\rightarrow$ Bấm nút **Yêu cầu tính tiền**.
- **Kịch bản E2E-06 (Cashier)**: Thu ngân đăng nhập `cashier1` $\rightarrow$ Vào màn hình **Thu ngân** $\rightarrow$ Thấy bàn `T1-01` ở trạng thái *Chờ thanh toán* $\rightarrow$ Bấm thanh toán $\rightarrow$ Kiểm tra chi tiết hóa đơn, VAT, phí DV $\rightarrow$ Chọn phương thức thanh toán $\rightarrow$ Xuất hóa đơn $\rightarrow$ Phiên đóng, bàn `T1-01` trở về trạng thái *Trống*.

---

### Giai đoạn 2: Kiểm thử Phân hệ Quản lý Chi nhánh (BranchManager)
Đăng nhập tài khoản `manager1` tại `/manager`:
- **Kịch bản BM-01 (Báo cáo)**: Kiểm tra màn hình **Báo cáo chi nhánh** $\rightarrow$ Dữ liệu doanh thu và số hóa đơn vừa thanh toán từ luồng E2E được cập nhật ngay lập tức.
- **Kịch bản BM-02 (Quản lý Bàn & QR)**: Vào **Quản lý bàn & QR** $\rightarrow$ Xem danh sách bàn các khu vực $\rightarrow$ Kiểm tra tính năng tạo bàn mới và xem/tải mã QR.
- **Kịch bản BM-03 (Thực đơn chi nhánh)**: Vào **Thực đơn chi nhánh** $\rightarrow$ Thao tác đè giá món (chỉnh giá bán riêng cho CN Quận 1) $\rightarrow$ Thao tác tạm ẩn/hết hàng một món ăn.
- **Kịch bản BM-04 (Nhân viên chi nhánh)**: Vào **Nhân viên chi nhánh** $\rightarrow$ Kiểm tra danh sách nhân sự tại CN Quận 1 (đảm bảo không xem lẫn nhân viên CN khác).
- **Kịch bản BM-05 (Cấu hình chi nhánh)**: Vào **Cấu hình chi nhánh** $\rightarrow$ Xem thông tin vận hành, giờ mở cửa, SĐT của chi nhánh mình.

---

### Giai đoạn 3: Kiểm thử Phân hệ Quản trị Toàn chuỗi (RestaurantAdmin)
Đăng nhập tài khoản `admin1` tại `/admin`:
- **Kịch bản AD-01 (Báo cáo chuỗi)**: Kiểm tra **Báo cáo toàn chuỗi** $\rightarrow$ Lọc xem doanh thu tổng tất cả chi nhánh và chuyển đổi xem từng chi nhánh.
- **Kịch bản AD-02 (Quản lý Chi nhánh)**: Vào **Quản lý chi nhánh** $\rightarrow$ Xem danh sách toàn bộ các chi nhánh trong chuỗi BBQ $\rightarrow$ Kiểm tra modal thêm chi nhánh và cấu hình tài chính/thuế VAT.
- **Kịch bản AD-03 (Thực đơn & Giá gốc)**: Vào **Thực đơn & Giá gốc** $\rightarrow$ Kiểm tra tab Danh mục món và tab Món ăn gốc $\rightarrow$ Xem chức năng thêm danh mục và thêm món mới toàn hệ thống.
- **Kịch bản AD-04 (Khuyến mãi chuỗi)**: Vào **Khuyến mãi chuỗi** $\rightarrow$ Xem danh sách các chương trình ưu đãi hiện có $\rightarrow$ Kiểm tra modal tạo chương trình khuyến mãi mới (% hoặc tiền mặt).
- **Kịch bản AD-05 (Nhân sự toàn hệ thống)**: Vào **Nhân sự toàn hệ thống** $\rightarrow$ Xem danh sách nhân viên mọi chi nhánh $\rightarrow$ Kiểm tra chức năng phân quyền và thêm nhân viên mới.

---

## 3. Quy cách Thu thập Minh chứng và Lập Báo cáo
1. **Chụp ảnh màn hình (Screenshots)**: Ở mỗi bước kiểm thử, chụp ảnh minh chứng rõ nét giao diện người dùng.
2. **Tổng hợp Báo cáo nghiệm thu (`bao_cao_kiem_thu_toan_dien.md`)**:
   - Bảng tổng kết trạng thái từng Test Case (Pass/Fail).
   - Hình ảnh đính kèm theo từng bước thao tác của từng Actor.
   - Đánh giá tính toàn vẹn dữ liệu và ma trận phân quyền.
