ĐẶC TẢ CHỨC NĂNG
ORDER MÓN ĂN NHÀ HÀNG
Phiên bản 2 — đã cập nhật  (26/08/2026)


MỤC LỤC

1. KHÁI NIỆM VÀ LUỒNG CHÍNH
1.1. Khái niệm
1.2. Luồng chính
Khách quét QR trên bàn. Hệ thống suy ra NHÀ HÀNG và CHI NHÁNH từ bàn mã QR.
Bàn chưa có phiên mở (ở trạng thái ĐÓNG) ⇒ tạo phiên CHỜ MỞ BÀN. Nếu bàn đã có phiên ĐANG PHỤC VỤ hoặc CHỜ MỞ BÀN ⇒ thiết bị tham gia vào phiên đó và hiển thị menu cho khách hàng. Nếu bàn đang ở trạng thái ĐẶT TRƯỚC ⇒ từ chối, báo 'Bàn đã được đặt trước, vui lòng gặp nhân viên' (FR-CUS-01, BR-29).
Phiên CHỜ MỞ BÀN không được xác nhận trong thời gian cấu hình của chi nhánh (mặc định 10 phút) ⇒ tự động chuyển ĐÃ HỦY, bàn mở lại được cho lượt quét mới (BR-27).
Phục vụ xác nhận mở bàn (BẮT BUỘC nhập số khách) ⇒ phiên chuyển trạng thái sang ĐANG PHỤC VỤ, cấp token phiên cho thiết bị khách.
Khách xem menu CỦA CHI NHÁNH: món của nhà hàng, trừ món chi nhánh đã ẩn, cộng món riêng của chi nhánh, giá lấy theo bản đè nếu có (BR-17). Món đang có khuyến mãi hiển thị giá gạch ngang giá gốc và hiển thị giá khuyến mãi (nếu chương trình còn lượt sử dụng, BR-23).
Khách chọn món, tùy chọn; gửi order. Món bán theo cân sinh dòng món ở trạng thái CHỜ CÂN — khách không nhập khối lượng.
Phục vụ xác nhận order của khách. Hệ thống chuyển các dòng món (trừ dòng CHỜ CÂN) sang trạng thái ĐANG CHẾ BIẾN và IN PHIẾU BẾP qua máy in nhiệt nối mạng. Với món bán theo cân, Phục vụ cân trước mặt khách, nhập số cân ⇒ dòng món mới chuyển ĐANG CHẾ BIẾN và in phiếu bếp lúc đó.
Nhân viên bếp tiếp nhận phiếu bếp (tách theo khu chế biến nếu chi nhánh có nhiều khu) và thực hiện chế biến món. Nhân viên bếp không trực tiếp thao tác trên hệ thống. Khi món hoàn thành, bếp sử dụng chuông hoặc phương thức thông báo nội bộ để báo cho Phục vụ.
Phục vụ nhận món từ bếp, mang món đến bàn và cập nhật dòng món sang trạng thái ĐÃ PHỤC VỤ. Màn hình khách được cập nhật trạng thái tương ứng (độ trễ ≤ 5 giây, T-01).
Nếu cần hủy món sau khi đã chuyển bếp (cháy, làm nhầm, hết nguyên liệu, khách đổi ý): Phục vụ hủy dòng món ở ĐANG CHẾ BIẾN hoặc ĐÃ PHỤC VỤ, khai rõ lý do và có tính tiền hay không; nếu không tính tiền phải có Quản lý chi nhánh duyệt (BR-24).
Khách yêu cầu thanh toán ⇒ phiên sang CHỜ THANH TOÁN, khóa gọi thêm món.
Thu ngân chốt bàn. Hệ thống áp khuyến mãi tự động (kiểm tra còn lượt sử dụng, BR-23), cộng chiết khấu tay nếu có, tính phí dịch vụ và VAT theo cấu hình đã snapshot lúc mở phiên (BR-08). Chọn hình thức thanh toán (tiền mặt hoặc chuyển khoản). Hệ thống chặn phát hành hóa đơn nếu còn dòng món ở CHỜ CÂN.
Thu tiền, phát hành hóa đơn điện tử với số hóa đơn riêng của chi nhánh (BR-19). Phát hành thất bại ⇒ chặn đóng bàn, Thu ngân thử lại.
Phiên sang ĐÃ ĐÓNG. Token khách hết hiệu lực ngay. Bàn sẵn sàng cho lượt mới.
2. VÒNG ĐỜI TRẠNG THÁI
2.1. Phiên bàn – trạng thái
⚑ CẬP NHẬT: Thêm trạng thái ĐÃ GỘP (BR-28): giải quyết khoảng trống trước đây — thao tác Gộp (FR-SRV-06/07) ảnh hưởng vòng đời phiên nhưng bảng 2.1/2.2 bản trước chưa mô tả.
2.2. Phiên bàn – bảng chuyển trạng thái
2.3. Dòng món – trạng thái
2.4. Dòng món – bảng chuyển trạng thái
⚑ CẬP NHẬT: Thêm transition CHỜ CÂN → ĐÃ HỦY: bản trước không có đường hủy cho món bán theo cân trước khi Phục vụ kịp cân — khách đổi ý ngay sau khi gửi sẽ không hủy được. Nay áp cùng tinh thần BR-03.
3. QUY TẮC NGHIỆP VỤ

⚑ CẬP NHẬT: Các quy tắc BR-23 → BR-27 dưới đây là MỚI, được bổ sung 
4. VAI TRÒ VÀ MA TRẬN PHÂN QUYỀN
4.1. Sáu vai trò
4.2. Quyền cấp chi nhánh
X = được phép · A = được phép nhưng cần duyệt · R = chỉ đọc · trống = không được phép
4.3. Quyền cấp nhà hàng và nền tảng
5. YÊU CẦU CHỨC NĂNG
5.1. Chi nhánh
5.2. Khách hàng
5.3. Phục vụ
5.4. Menu
5.5. Bàn
5.6. Khuyến mãi
5.7. Thanh toán và hóa đơn
5.8. Báo cáo
5.9. Quản trị nhà hàng
5.10. Quản trị hệ thống
5.11. Nhật ký hoạt động 
6. RÀNG BUỘC KỸ THUẬT

