ĐẶC TẢ CHỨC NĂNG
ORDER MÓN ĂN NHÀ HÀNG
Phiên bản 2 — đã cập nhật  (26/08/2026)
Phần | Công nghệ
Front-end | React + TypeScript
Back-end | Spring Boot (Java)
Database | MySQL


Ký hiệu | Ý nghĩa
M / S / C | MUST bắt buộc có ở bản chạy thật đầu tiên · SHOULD nên có, lùi được · COULD làm khi còn nguồn lực
BR-nn | Quy tắc nghiệp vụ (Mục 3) – bắt buộc tuân thủ
Tn | Ràng buộc kỹ thuật (Mục 6)


MỤC LỤC

1. KHÁI NIỆM VÀ LUỒNG CHÍNH
1.1. Khái niệm
Khái niệm | Định nghĩa
Nhà hàng | Đơn vị kinh doanh vận hành trên hệ thống, có thể có một hoặc nhiều chi nhánh. Là tenant gốc: mỗi nhà hàng được quản lý như một thực thể độc lập với dữ liệu riêng, tách biệt hoàn toàn với các nhà hàng khác (BR-21).
Chi nhánh (Branch) | Một cửa hàng vật lý của nhà hàng. Có địa chỉ, giờ mở cửa, cấu hình riêng (Mục 5.1 – FR-BRN-02), có thể có mã số thuế riêng.
Bàn (Table) | Thực thể vật lý thuộc đúng một chi nhánh, có mã QR gắn liền. Bàn KHÔNG mang trạng thái order.
Phiên bàn (Session) | Một lượt khách sử dụng bàn, từ mở bàn đến thanh toán xong. Mọi order và hóa đơn gắn với PHIÊN, không gắn trực tiếp với bàn. Đây là khái niệm trung tâm của hệ thống.
Order | Một lần gửi món. Một phiên có nhiều order (gọi thêm lần 2, lần 3).
Dòng món (Order Item) | Một món trong order kèm số lượng, tùy chọn, ghi chú. ĐÂY là đơn vị theo dõi trạng thái chế biến, không phải Order.
Món gốc | Món định nghĩa ở cấp NHÀ HÀNG, có giá gốc. Mặc định mọi chi nhánh đều bán.
Bản đè (Override) | Cấu hình cấp CHI NHÁNH đè lên món gốc: đổi giá, hoặc tạm ẩn không bán. Chi nhánh cũng tạo được món riêng chỉ mình có. Xem BR-17.
Món bán theo cân | Món tính tiền theo khối lượng thật (kg/gram), số cân do Phục vụ cân và nhập tay TRƯỚC khi chuyển bếp (xem trạng thái CHỜ CÂN, Mục 2.3).
Nhóm tùy chọn món | Tập lựa chọn cho một món (VD: mức cay, size), khai báo ở cấp NHÀ HÀNG, dùng lại được cho nhiều món. Xem FR-MNU-05.
Chương trình khuyến mãi | Quy tắc giảm giá cấu hình trước, hệ thống TỰ ÁP khi thỏa điều kiện, có thể giới hạn tổng số lượt sử dụng (BR-23). Khác với chiết khấu thủ công do thu ngân bấm. Xem nhóm FR-PRO.
Phân công (Assignment) | Bộ ba (nhân viên, chi nhánh, vai trò). Một nhân viên có nhiều phân công. Vai trò cấp nhà hàng và nền tảng không gắn chi nhánh.
Đặt bàn trước | Bàn được nhân viên đánh dấu giữ chỗ trước cho khách vào một giờ hẹn cụ thể (thường gần giờ khách đến). Là một trạng thái của Phiên bàn (không phải entity riêng) — xem trạng thái ĐẶT TRƯỚC, Mục 2.1. Chỉ nhằm mục đích để nhân viên nhìn sơ đồ bàn biết bàn nào đã có khách đặt; KHÔNG hỗ trợ đặt nhiều khung giờ khác nhau cho cùng một bàn trong ngày. Xem BR-29, FR-TBL-03.

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
Trạng thái | Ý nghĩa
ĐẶT TRƯỚC | Bàn đã được giữ chỗ trước cho khách (qua điện thoại/trực tiếp), chưa có khách tới ngồi. CHƯA cho gửi order, chưa cấp token khách. Được tính là 'đang bận' để chặn Quét QR/mở bàn trùng (BR-01, BR-29).
CHỜ MỞ BÀN | Có người quét QR, nhân viên chưa xác nhận. CHƯA cho gửi order. Tự động chuyển ĐÃ HỦY nếu không được xác nhận trong thời gian cấu hình theo chi nhánh, mặc định 10 phút (BR-27).
ĐANG PHỤC VỤ | Phiên hoạt động. Cho gọi món, gọi thêm, sửa, hủy theo quy tắc.
CHỜ THANH TOÁN | Đã chốt bàn. KHÓA gọi thêm món. Chỉ Quản lý chi nhánh mở lại được.
ĐÃ ĐÓNG | Thu đủ tiền, đã phát hành hóa đơn. Bất biến. Token khách hết hiệu lực.
ĐÃ HỦY | Quét nhầm / mở nhầm bàn, phiên CHỜ MỞ BÀN hết hạn tự động (BR-27), hoặc hủy đặt trước (khách báo không tới / quá giờ giữ chỗ, BR-29).
ĐÃ GỘP | Phiên đã được gộp vào một phiên khác (FR-SRV-06). Bất biến, chỉ giữ để truy vết; toàn bộ order/dòng món/chiết khấu đã chuyển sang phiên đích (BR-28).

⚑ CẬP NHẬT: Thêm trạng thái ĐÃ GỘP (BR-28): giải quyết khoảng trống trước đây — thao tác Gộp (FR-SRV-06/07) ảnh hưởng vòng đời phiên nhưng bảng 2.1/2.2 bản trước chưa mô tả.
2.2. Phiên bàn – bảng chuyển trạng thái
Từ | Sự kiện | Sang | Người thực hiện | Điều kiện
(không có) | Đặt bàn trước | ĐẶT TRƯỚC | Phục vụ, QL chi nhánh | Bàn không có phiên nào đang mở (BR-01); nhập tên/SĐT khách, thời gian dự kiến đến, số khách dự kiến (BR-29)
ĐẶT TRƯỚC | Khách đến, xác nhận mở bàn | ĐANG PHỤC VỤ | Phục vụ | Bắt buộc nhập số khách thực tế (BR-29)
ĐẶT TRƯỚC | Hủy đặt trước / quá giờ không đến | ĐÃ HỦY | Phục vụ, QL chi nhánh, Hệ thống (tự động nếu quá giờ cấu hình) | Ghi lý do nếu hủy tay (BR-29)
(không có) | Quét QR | CHỜ MỞ BÀN | Khách, Phục vụ | Bàn không có phiên nào đang mở (BR-01)
CHỜ MỞ BÀN | Xác nhận mở bàn | ĐANG PHỤC VỤ | Phục vụ | Bắt buộc nhập số lượng khách
CHỜ MỞ BÀN | Hủy tay hoặc hết hạn tự động | ĐÃ HỦY | Phục vụ, Hệ thống (tự động) | Không bắt buộc nhập lý do (BR-27)
ĐANG PHỤC VỤ | Yêu cầu thanh toán | CHỜ THANH TOÁN | Khách, Phục vụ, Thu ngân | 
CHỜ THANH TOÁN | Mở lại bàn | ĐANG PHỤC VỤ | Quản lý CN | Chưa phát hành hóa đơn
CHỜ THANH TOÁN | Thu đủ tiền | ĐÃ ĐÓNG | Thu ngân | Đã thu = phải thu; hóa đơn phát hành xong; không còn dòng món ở CHỜ CÂN
ĐANG PHỤC VỤ | Hủy phiên | ĐÃ HỦY | Quản lý CN | Bắt buộc nhập lý do; ghi nhật ký
ĐANG PHỤC VỤ (phiên nguồn) | Gộp bàn | ĐÃ GỘP | Phục vụ (cần duyệt), Thu ngân, QL chi nhánh | Cùng chi nhánh; cùng bộ số VAT/phí dịch vụ (BR-26); phiên đích nhận toàn bộ dữ liệu (BR-28)

2.3. Dòng món – trạng thái
Trạng thái | Ý nghĩa
CHỜ CÂN | Áp dụng riêng cho món bán theo cân. Khách đã gửi nhưng chưa có số cân thật. Tạm tính hiển thị "tính theo cân thật", cộng 0đ. Không thể chuyển bếp và không được phát hành hóa đơn khi còn dòng ở trạng thái này .
CHỜ XÁC NHẬN | Khách đã gửi, nhân viên chưa xác nhận. Khách còn tự hủy được.
ĐANG CHẾ BIẾN | Dòng món đã được Phục vụ xác nhận (hoặc đã cân xong với món theo cân) và yêu cầu chế biến đã được chuyển đến bếp thông qua phiếu bếp. Từ trạng thái này, khách không còn được tự hủy món — chỉ Phục vụ hủy được, theo BR-24.
ĐÃ PHỤC VỤ | Đã mang tới bàn. Vẫn hủy được trong trường hợp đặc biệt (món lỗi phát hiện sau khi phục vụ), theo BR-24.
ĐÃ HỦY | Hủy trước khi chế biến (không tính tiền), hoặc hủy sau khi chế biến/phục vụ theo BR-24 (có thể tính tiền hoặc không, tùy lý do).

2.4. Dòng món – bảng chuyển trạng thái
Từ | Sự kiện | Sang | Người thực hiện | Điều kiện
(không có) | Gửi order, món bán theo cân | CHỜ CÂN | Khách, Phục vụ | Phiên ĐANG PHỤC VỤ; món còn hàng TẠI CHI NHÁNH
CHỜ CÂN | Nhập số cân | ĐANG CHẾ BIẾN | Phục vụ | Số cân > 0; hệ thống in phiếu bếp ngay khi chuyển
CHỜ CÂN | Hủy trước khi cân | ĐÃ HỦY | Khách, Phục vụ | Không tính tiền, tự do (BR-03)
(không có) | Gửi order, món thường | CHỜ XÁC NHẬN | Khách, Phục vụ | Phiên ĐANG PHỤC VỤ; món còn hàng TẠI CHI NHÁNH
CHỜ XÁC NHẬN | Xác nhận | ĐANG CHẾ BIẾN | Phục vụ | In phiếu bếp
CHỜ XÁC NHẬN | Hủy | ĐÃ HỦY | Khách, Phục vụ | Không tính tiền (BR-03)
ĐANG CHẾ BIẾN | Xác nhận đã phục vụ món | ĐÃ PHỤC VỤ | Phục vụ | 
ĐANG CHẾ BIẾN | Hủy sau khi vào bếp | ĐÃ HỦY | Phục vụ | Bắt buộc chọn lý do (Lỗi nhà hàng – không tính tiền / Khách đổi ý – vẫn tính tiền); nếu không tính tiền phải có Quản lý CN duyệt; in phiếu hủy gửi bếp; ghi nhật ký BR-12 (BR-24)
ĐÃ PHỤC VỤ | Hủy sau khi đã phục vụ | ĐÃ HỦY | Phục vụ | Điều kiện như trên (BR-24)

⚑ CẬP NHẬT: Thêm transition CHỜ CÂN → ĐÃ HỦY: bản trước không có đường hủy cho món bán theo cân trước khi Phục vụ kịp cân — khách đổi ý ngay sau khi gửi sẽ không hủy được. Nay áp cùng tinh thần BR-03.
3. QUY TẮC NGHIỆP VỤ
# | Quy tắc
BR-01 | Một bàn tại một thời điểm chỉ có tối đa 01 phiên ở trạng thái khác ĐÃ ĐÓNG/ĐÃ HỦY/ĐÃ GỘP. Chặn ở tầng CSDL, KHÔNG chỉ chặn ở giao diện. ⚑ CẬP NHẬT: bổ sung ĐÃ GỘP vào danh sách loại trừ, vì phiên bị gộp giải phóng bàn nguồn về trống (xem BR-28, FR-SRV-06).
BR-02 | Mọi Order và Hóa đơn bắt buộc thuộc đúng 01 phiên bàn.
BR-03 | Dòng món ở CHỜ XÁC NHẬN hoặc CHỜ CÂN: hủy tự do, không tính tiền. ⚑ CẬP NHẬT: bổ sung CHỜ CÂN vào phạm vi — trước đó món bán theo cân không có đường hủy trước khi Phục vụ kịp cân (xem bảng 2.4).
BR-04 | Phiên ở CHỜ THANH TOÁN: từ chối mọi order mới. Muốn gọi thêm phải để Quản lý CN mở lại bàn.
BR-05 | Món hết hàng TẠI CHI NHÁNH ĐANG XÉT không hiển thị trên menu khách. Nếu món nằm trong giỏ: khi bấm Gửi, hiển thị thông báo món cụ thể món nào hết để khách hàng xác nhận.
BR-06 | Trạng thái Hết hàng tự reset về Còn hàng vào đầu mỗi ngày kinh doanh, theo giờ cấu hình CỦA TỪNG CHI NHÁNH.
BR-07 | Khi gửi order, hệ thống snapshot và lưu cứng đơn giá bán trước khuyến mãi của dòng món (kể cả phần cộng thêm của tùy chọn món), được xác định từ giá gốc hoặc giá đè của chi nhánh theo BR-17. Thông tin khuyến mãi áp dụng và số tiền giảm được lưu riêng. Việc thay đổi giá hoặc chương trình khuyến mãi sau thời điểm gửi order không làm thay đổi dòng món đã gửi. Riêng dòng món bán theo cân: đơn giá/kg snapshot ngay khi gửi, thành tiền chỉ chốt sau khi có số cân thật.
BR-08 | Thuế suất VAT và tỷ lệ phí dịch vụ áp theo cấu hình CỦA CHI NHÁNH tại thời điểm MỞ PHIÊN, sao chép cứng vào phiên. Khi Quản trị nhà hàng đổi VAT/phí dịch vụ mà chi nhánh còn phiên ĐANG PHỤC VỤ hoặc CHỜ THANH TOÁN, hệ thống cảnh báo rõ số phiên đang mở vẫn dùng số cũ trước khi lưu cấu hình.
BR-09 | Hóa đơn đã phát hành là BẤT BIẾN. Không sửa, không xóa. Sai sót chỉ xử lý bằng hóa đơn điều chỉnh hoặc thay thế.
BR-10 | Chiết khấu thủ công vượt ngưỡng cấu hình CỦA CHI NHÁNH bắt buộc có duyệt của Quản lý CN. Ghi nhật ký người duyệt.
BR-11 | Token phiên của khách hết hiệu lực NGAY khi phiên sang ĐÃ ĐÓNG hoặc ĐÃ HỦY. Khách lượt trước không được thấy dữ liệu lượt sau và ngược lại.
BR-12 | Mọi thao tác đổi số tiền, đổi trạng thái dòng món, đổi trạng thái phiên bàn (mở, hủy, gộp, tách), HOẶC thay đổi cấu hình chi nhánh/nhà hàng phải sinh bản ghi nhật ký: nhà hàng, chi nhánh, người thực hiện, người duyệt, thời điểm, giá trị trước, giá trị sau, lý do. ⚑ CẬP NHẬT: bổ sung rõ "đổi trạng thái phiên bàn" vào phạm vi (trước đó chỉ ngầm định qua FR-LOG-01, nay quy định trực tiếp trong BR để không lệ thuộc cách đọc FR) (xem FR-LOG-01).
BR-13 | Thứ tự tính tiền, áp đúng trình tự sau: (1) Tiền hàng = Σ(đơn giá × số lượng các dòng món tính tiền) (2) − Khuyến mãi tự động cấp món (BR-22) (3) − Khuyến mãi tự động cấp hóa đơn (BR-22) (4) − Chiết khấu thủ công (5) + Phí dịch vụ, tính trên kết quả bước (4) (6) + VAT, tính trên kết quả bước (5)
BR-14 | Nhiều thiết bị của cùng một bàn dùng chung một phiên nhưng CÓ GIỎ HÀNG RIÊNG. Order ghi nhận theo thứ tự đến, không ghi đè lẫn nhau.
BR-15 | Các thực thể nghiệp vụ phát sinh tại chi nhánh gồm bàn, mã QR, phiên bàn, order, chiết khấu, hóa đơn và thanh toán thuộc đúng một chi nhánh và qua đó thuộc đúng một nhà hàng. Món gốc, danh mục và nhóm tùy chọn món thuộc cấp nhà hàng; bản đè, trạng thái còn/hết và món riêng của chi nhánh thuộc cấp chi nhánh.
BR-16 | Tên bàn duy nhất TRONG PHẠM VI MỘT CHI NHÁNH, không phải toàn hệ thống. VD bàn "B01" tồn tại đồng thời ở mọi chi nhánh của mọi nhà hàng.
BR-17 | Giá và việc niêm yết món xác định theo thứ tự: (1) nếu chi nhánh có bản đè cho món đó thì lấy giá và trạng thái niêm yết của bản đè; (2) nếu không, lấy giá gốc cấp nhà hàng và mặc định là có niêm yết. Món riêng của chi nhánh chỉ hiện ở chi nhánh sở hữu. Giá cuối cùng vẫn snapshot vào dòng món theo BR-07.
BR-18 | Người dùng chỉ thao tác được trên chi nhánh mình được phân công. Vai trò cấp nhà hàng và nền tảng không gắn chi nhánh.
BR-19 | Số hóa đơn đánh riêng theo từng chi nhánh, duy nhất trong phạm vi (chi nhánh, số hóa đơn).
BR-20 | Mã số thuế dùng khi phát hành hóa đơn: nếu chi nhánh có mã số thuế riêng thì dùng của chi nhánh; để trống thì dùng của nhà hàng. Chưa chốt nhà cung cấp hóa đơn điện tử — cấu trúc chừa chỗ cho cả hai.
BR-21 | CÁCH LY NHÀ HÀNG. Không một truy vấn nào được trả về dữ liệu của nhà hàng khác, trong bất kỳ hoàn cảnh nào, kể cả khi người gọi là Quản trị nền tảng. Triển khai: một CSDL dùng chung, cột restaurant_id bắt buộc trên mọi bảng nghiệp vụ, khóa ngoại tổ hợp để không thể trỏ chéo nhà hàng, và một lớp chặn DUY NHẤT ở tầng truy cập dữ liệu (không dựa vào từng câu truy vấn tự thêm điều kiện lọc). Quản trị nền tảng không có ngoại lệ truy cập dữ liệu kinh doanh; hỗ trợ sự cố chỉ dựa trên nhật ký kỹ thuật (không chứa dữ liệu kinh doanh). Đây là quy tắc quan trọng nhất tài liệu. Vi phạm không phải bug mà là sự cố pháp lý.
BR-22 | ƯU TIÊN KHUYẾN MÃI. Khuyến mãi cấp MÓN và cấp HÓA ĐƠN áp độc lập, cộng dồn được với nhau. Trong CÙNG MỘT cấp, nếu nhiều chương trình cùng thỏa điều kiện: chọn chương trình có độ ưu tiên cao nhất; nếu độ ưu tiên bằng nhau thì chọn chương trình CÓ LỢI NHẤT CHO KHÁCH. Không bao giờ áp hai chương trình cùng cấp lên cùng một đối tượng. Chiết khấu thủ công áp SAU cùng, trên phần còn lại.


⚑ CẬP NHẬT: Các quy tắc BR-23 → BR-27 dưới đây là MỚI, được bổ sung 
# | Quy tắc
BR-23 | GIỚI HẠN LƯỢT SỬ DỤNG KHUYẾN MÃI. Chương trình khuyến mãi có thể cấu hình tổng số lượt áp dụng tối đa. Khi số lượt đã dùng = giới hạn ⇒ chương trình tự động ngừng áp dụng dù còn hiệu lực ngày/giờ, không cần tắt thủ công. Đếm lượt phải chặn ở tầng CSDL (transaction/lock) để tránh sai số khi nhiều phiên cùng áp gần hết quota. Lượt chỉ trừ khi order thực sự phát sinh (gửi order với KM cấp món, hoặc phát hành hóa đơn với KM cấp hóa đơn); hủy DÒNG MÓN trước khi chế biến (CHỜ XÁC NHẬN hoặc CHỜ CÂN → ĐÃ HỦY, BR-03) thì hoàn lại lượt tương ứng — hóa đơn đã phát hành KHÔNG hoàn lượt vì là bất biến (BR-09). Hủy dòng món SAU KHI ĐÃ VÀO BẾP (ĐANG CHẾ BIẾN/ĐÃ PHỤC VỤ → ĐÃ HỦY, BR-24) — trường hợp trước đó chưa được BR này đề cập — xử lý theo lý do hủy: 'Lỗi nhà hàng – không tính tiền' ⇒ HOÀN lượt (dòng món không thu tiền nên không hợp lý giữ quota khuyến mãi đã trừ); 'Khách đổi ý – vẫn tính tiền' ⇒ KHÔNG hoàn lượt (dòng món vẫn được tính vào doanh thu nên khuyến mãi vẫn coi như đã áp dụng thành công). Bộ đếm lượt tính CHUNG TOÀN NHÀ HÀNG cho mỗi chương trình, không tách riêng theo từng chi nhánh, kể cả khi chương trình chỉ áp cho một số chi nhánh nhất định — vì bản chất là một ngân sách khuyến mãi duy nhất do Quản trị nhà hàng cấp; muốn giới hạn riêng theo từng chi nhánh thì tạo chương trình riêng cho từng chi nhánh đó.
BR-24 | HỦY DÒNG MÓN SAU KHI ĐÃ VÀO BẾP. Cho phép hủy dòng món ở ĐANG CHẾ BIẾN và ĐÃ PHỤC VỤ, do Phục vụ thực hiện. Bắt buộc chọn 1 trong 2 lý do: "Lỗi nhà hàng – không tính tiền" hoặc "Khách đổi ý – vẫn tính tiền". Trường hợp không tính tiền bắt buộc Quản lý CN duyệt (áp dụng tinh thần BR-10). Hệ thống in phiếu hủy gửi xuống bếp. Mọi thao tác ghi nhật ký theo BR-12.
BR-25 | GỘP BÀN – KHUYẾN MÃI. Sau khi gộp hai phiên: khuyến mãi cấp HÓA ĐƠN được TÍNH LẠI trên tổng hóa đơn mới; khuyến mãi cấp MÓN giữ nguyên theo snapshot cũ (không đụng tới, đúng BR-07). Nếu kết quả tính lại bất lợi hơn cho khách so với tổng hai hóa đơn riêng, hệ thống giữ mức có lợi hơn cho khách (đúng tinh thần BR-22). Chiết khấu thủ công của từng phiên giữ nguyên và cộng dồn, không yêu cầu nhập lại.
BR-26 | GỘP BÀN – VAT VÀ PHÍ DỊCH VỤ. Chỉ cho gộp hai phiên có CÙNG bộ số VAT/phí dịch vụ đã snapshot (BR-08). Nếu hai phiên khác bộ số ⇒ CHẶN gộp, thông báo rõ lý do. Thao tác chuyển bàn (không gộp phiên) luôn giữ nguyên bộ số cũ của phiên, không bị ảnh hưởng.
BR-27 | PHIÊN CHỜ MỞ BÀN TỰ HỦY. Phiên ở trạng thái CHỜ MỞ BÀN không được Phục vụ xác nhận trong khoảng thời gian cấu hình theo từng chi nhánh (mặc định 10 phút) sẽ tự động chuyển ĐÃ HỦY, không yêu cầu nhập lý do. Phục vụ cũng được hủy tay bất kỳ lúc nào mà không cần vai trò Quản lý CN.
BR-28  | GỘP  — TRẠNG THÁI PHIÊN. Khi gộp bàn (FR-SRV-06): phiên nguồn chuyển sang trạng thái ĐÃ GỘP ( xem Mục 2.1/2.2) — KHÔNG dùng ĐÃ ĐÓNG (vì chưa phát hành hóa đơn riêng) và KHÔNG dùng ĐÃ HỦY (vì dữ liệu không bị hủy, chỉ chuyển sang phiên đích). Phiên ĐÃ GỘP là bất biến, chỉ giữ lại để truy vết; toàn bộ order/dòng món/chiết khấu được chuyển quyền sở hữu (re-parent) sang phiên đích.
BR-29 | ĐẶT BÀN TRƯỚC. Phiên ở trạng thái ĐẶT TRƯỚC được tính là 'đang chiếm bàn' theo BR-01 — chặn Quét QR tạo CHỜ MỞ BÀN và chặn Phục vụ mở bàn walk-in trên cùng bàn (FR-SRV-02), cho tới khi phiên ĐẶT TRƯỚC được xác nhận thành ĐANG PHỤC VỤ hoặc bị hủy. Chi nhánh cấu hình thời gian giữ chỗ tối đa sau giờ hẹn (mặc định 15 phút, FR-BRN-02); quá thời gian này mà chưa xác nhận khách đến, hệ thống TỰ ĐỘNG chuyển ĐÃ HỦY (cùng cơ chế job nền với BR-27, xem T-08), giải phóng bàn cho khách vãng lai. Đặt trước KHÔNG giữ chỗ menu/giá — giá món chỉ chốt khi khách thực sự gửi order sau khi đã ĐANG PHỤC VỤ (BR-07). PHẠM VI BẢN ĐẦU (đã xác nhận với chủ dự án): đây CHỈ là công cụ đánh dấu giữ chỗ GẦN GIỜ để Phục vụ nhìn sơ đồ bàn biết bàn nào đã có khách đặt, KHÔNG phải hệ thống đặt bàn theo khung giờ/lịch (calendar booking) — vì bàn bị khóa ngay khi đánh dấu nên KHÔNG đặt được nhiều lượt khác giờ cho cùng một bàn trong ngày, và không nên đánh dấu quá sớm trước giờ hẹn (sẽ khóa bàn lãng phí công suất). Bản đầu CHƯA hỗ trợ đặt cọc giữ chỗ; các phần này nằm ngoài phạm vi bản chạy thật đầu tiên nếu phát sinh.

4. VAI TRÒ VÀ MA TRẬN PHÂN QUYỀN
4.1. Sáu vai trò
Vai trò | Phạm vi | Mục tiêu và giới hạn
Khách hàng | Phiên bàn | Gọi món, xem trạng thái món đã order, xem được hóa đơn tạm tính. Không đăng nhập, dùng token phiên.
Phục vụ | Chi nhánh | Mở bàn, đặt bàn trước, xác nhận order, cân và nhập số cân, mang món ra, đánh dấu món đã phục vụ, hủy dòng món (kể cả sau khi vào bếp, theo BR-24), gộp/chuyển/tách bàn.
Thu ngân | Chi nhánh | Đóng bàn, thu tiền, xuất hóa đơn. KHÔNG mở bàn.
Quản lý chi nhánh | Chi nhánh | Đè giá và niêm yết món cho chi nhánh mình, cấu hình chi nhánh (FR-BRN-02), duyệt hủy món/chiết khấu vượt ngưỡng, xem báo cáo và nhật ký chi nhánh mình.
Quản trị nhà hàng | Nhà hàng | Vai trò cao nhất trong một nhà hàng. Quản lý món gốc, giá gốc, khuyến mãi, nhóm tùy chọn món. Tạo chi nhánh, quản lý nhân viên và phân công, cấu hình vai trò và thông tin nhà hàng, cấu hình VAT/phí dịch vụ/ngưỡng chiết khấu của mọi chi nhánh. Xem báo cáo, xem nhật ký.
Quản trị nền tảng | Nền tảng | TUYỆT ĐỐI KHÔNG xem được dữ liệu kinh doanh của khách hàng (BR-21), không có ngoại lệ kể cả khi xử lý sự cố. Chỉ thao tác trên nhật ký kỹ thuật.

4.2. Quyền cấp chi nhánh
X = được phép · A = được phép nhưng cần duyệt · R = chỉ đọc · trống = không được phép
Chức năng | Khách | Phục vụ | Thu ngân | QL chi nhánh | Quản trị NH
Quét QR, xem menu | X | X |  | X | X
Gửi order | X | X |  | X | X
Xác nhận order |  | X |  | X | X
Hủy món chưa chế biến | X | X |  | X | X
Hủy món ĐANG CHẾ BIẾN / ĐÃ PHỤC VỤ |  | X (A nếu không tính tiền) |  | A | A
Cập nhật trạng thái chế biến |  | X |  | X | X
Nhập/sửa số cân |  | X |  | X | X
Báo hết món tại chi nhánh |  |  |  | X | X
Bỏ đánh dấu hết món |  |  |  | X | X
Đặt bàn trước |  | X |  | X | X
Mở phiên bàn (tách từ "Mở/đóng") |  | X |  | X | X
Đóng phiên bàn (tách từ "Mở/đóng") |  |  | X | X | X
Chuyển / gộp bàn |  | A | X | X | X
Xem tạm tính của bàn | X | X | X | X | X
Thu tiền, đóng bàn |  |  | X | X | X
Chiết khấu tay |  |  | X | X | X
Phát hành hóa đơn điện tử |  |  | X | X | X
Quản lý bàn, mã QR |  |  |  | X | X
Tạo món riêng của chi nhánh |  |  |  | X | X
Cấu hình chi nhánh — giờ giấc, TK ngân hàng, thời gian tự hủy phiên (FR-BRN-02) |  |  |  | X | X
Cấu hình chi nhánh — VAT, phí dịch vụ, ngưỡng chiết khấu, MST riêng (chỉ Quản trị NH) |  |  |  |  | X
Xem báo cáo chi nhánh mình |  |  |  | X | X
Xem nhật ký hoạt động chi nhánh mình  FR-LOG-01) |  |  |  | R | R

4.3. Quyền cấp nhà hàng và nền tảng
Chức năng | QL chi nhánh | Quản trị nhà hàng | QT nền tảng
Quản lý Menu nhà hàng |  | X | 
Quản lý danh mục |  | X | 
Quản lý nhóm tùy chọn món |  | X | 
Quản lý chương trình khuyến mãi |  | X | 
Xem báo cáo |  | X | 
Quản lý chi nhánh |  | X | 
Quản lý nhân viên |  | X | 
Cấu hình vai trò & quyền |  | X | 
Cấu hình nhà hàng (MST, logo, HĐĐT) |  | X | 
Xem nhật ký hoạt động toàn nhà hàng | X (chỉ chi nhánh mình) | X | 
Xem dữ liệu kinh doanh của khách |  |  | KHÔNG BAO GIỜ

5. YÊU CẦU CHỨC NĂNG
5.1. Chi nhánh
ID | Chức năng | Ưu tiên | Actor | Yêu cầu chi tiết & tiêu chí nghiệm thu
FR-BRN-01 | Quản lý chi nhánh | M | Quản trị nhà hàng | Tạo/sửa/ngừng hoạt động chi nhánh. Mỗi chi nhánh: mã, tên, địa chỉ, điện thoại. Mã chi nhánh duy nhất trong nhà hàng, KHÔNG sửa sau khi đã phát sinh hóa đơn (BR-19). KHÔNG xóa chi nhánh đã có giao dịch, chỉ ngừng hoạt động. Chi nhánh ngừng hoạt động: chặn mở phiên mới, dữ liệu lịch sử và báo cáo vẫn xem được. Tạo chi nhánh thứ hai trở đi: cho phép sao chép CẤU HÌNH VẬN HÀNH và KHU VỰC/BÀN từ chi nhánh có sẵn. KHÔNG sao chép bản đè giá.
FR-BRN-02 | Cấu hình chi nhánh | M | Quản lý CN, Quản trị nhà hàng | Nhóm 1 — Quản lý CN sửa được: giờ mở–đóng cửa, giờ bắt đầu ngày kinh doanh (BR-06), tài khoản ngân hàng nhận chuyển khoản (FR-PAY-03), thời gian tự hủy phiên CHỜ MỞ BÀN (BR-27, mặc định 10 phút), thời gian giữ chỗ tối đa cho ĐẶT TRƯỚC (BR-29, mặc định 15 phút sau giờ hẹn). Nhóm 2 — CHỈ Quản trị nhà hàng sửa được: thuế suất VAT, tỷ lệ phí dịch vụ, ngưỡng chiết khấu cần duyệt (BR-10), mã số thuế riêng của chi nhánh (BR-20). Đổi VAT/phí dịch vụ khi chi nhánh còn phiên đang mở ⇒ cảnh báo rõ số phiên bị ảnh hưởng trước khi lưu (BR-08). Phí dịch vụ áp mặc định mọi hóa đơn theo tỷ lệ cấu hình; ngoại lệ miễn phí dịch vụ xử lý qua chiết khấu thủ công (FR-PRO-02), không có cờ bật/tắt riêng. Mọi thay đổi ghi nhật ký theo BR-12 (đã mở rộng phạm vi).

5.2. Khách hàng
ID | Chức năng | Ưu tiên | Actor | Yêu cầu chi tiết & tiêu chí nghiệm thu
FR-CUS-01 | Quét QR | M | Khách hàng | Quét QR mở trang menu: không đăng nhập. Hệ thống suy ra NHÀ HÀNG và CHI NHÁNH từ bàn. Khách không chọn gì. Bàn chưa có phiên ⇒ tạo phiên CHỜ MỞ BÀN, khách thấy 'Đang chờ nhân viên xác nhận'. Bàn đã có phiên ĐANG PHỤC VỤ hoặc CHỜ MỞ BÀN ⇒ tham gia thẳng vào phiên đó (không tạo phiên mới), thấy món cả bàn đã gọi. Bàn đang ở trạng thái ĐẶT TRƯỚC ⇒ từ chối tạo phiên mới, hiển thị 'Bàn đã được đặt trước, vui lòng gặp nhân viên để được hỗ trợ'. Phiên ĐÃ ĐÓNG hoặc ĐÃ HỦY ⇒ quét lại tạo phiên mới, tuyệt đối không thấy dữ liệu phiên cũ (BR-11). Bàn thuộc chi nhánh ngừng hoạt động hoặc nhà hàng bị tạm ngưng ⇒ từ chối, báo rõ.
FR-CUS-02 | Xem menu | M | Khách hàng | Menu hiển thị là menu CỦA CHI NHÁNH, tính theo BR-17. Món nhóm theo danh mục, có thanh điều hướng. Mỗi món: tên, hình, mô tả ngắn, giá của chi nhánh đó, nhóm tùy chọn (nếu có, FR-MNU-05). Món đang khuyến mãi VÀ còn lượt sử dụng (BR-23): hiện giá gốc gạch ngang và giá sau giảm. Món bán theo cân: hiện rõ đơn giá theo kg và ghi chú 'giá cuối tính theo cân thật'. Món hết tại chi nhánh KHÔNG hiển thị (BR-05).
FR-CUS-03 | Tìm kiếm và lọc món | S | Khách hàng | Tìm không phân biệt hoa thường và có/không dấu ('ga nuong' ⇒ 'Gà nướng'). Không cần hỗ trợ từ đồng nghĩa/viết tắt . Lọc theo danh mục. Chỉ tìm trong menu của chi nhánh hiện tại.
FR-CUS-04 | Tùy chỉnh món và thêm vào giỏ hàng | M | Khách hàng | Chọn số lượng, ghi chú tự do tối đa 200 ký tự. Với món bán theo cân: không nhập số lượng/khối lượng, chỉ chọn món. Tùy chọn bắt buộc (theo nhóm tùy chọn, FR-MNU-05) chưa chọn ⇒ chặn thêm vào giỏ. Giỏ hàng: thêm/sửa số lượng/xóa; tạm tính cập nhật thời gian thực, đã trừ khuyến mãi. Giỏ giữ được khi khách đóng trình duyệt và mở lại trong cùng phiên. Ghi chú in nguyên văn lên phiếu bếp.
FR-CUS-05 | Gửi order | M | Khách hàng | Gửi order thành công ⇒ giỏ rỗng, món vào 'Món đã gọi'. Món thường ⇒ CHỜ XÁC NHẬN; món bán theo cân ⇒ CHỜ CÂN. Phiên không còn ĐANG PHỤC VỤ ⇒ vô hiệu nút Gửi. CHỈ áp dụng cho khuyến mãi CẤP MÓN. Nếu khuyến mãi cấp món trong giỏ vừa hết lượt sử dụng (BR-23) đúng lúc bấm Gửi, hiển thị thông báo rõ chương trình nào không còn áp dụng, tính lại giá dòng món đó theo giá gốc/bản đè (BR-17), yêu cầu khách xác nhận trước khi gửi order với giá mới — áp dụng cùng cơ chế với BR-05 (món hết hàng). Khuyến mãi CẤP HÓA ĐƠN không kiểm tra ở bước này — cấp hóa đơn chỉ được tính một lần khi Thu ngân chốt bàn (xem FR-PAY-01), không gắn với một lần gửi order cụ thể nên không cần xác nhận của khách tại đây.
FR-CUS-06 | Gọi thêm món | M | Khách hàng | Order lần 2 trở đi là phiếu riêng, đánh số thứ tự lượt gọi. Màn hình 'Món đã gọi' gộp toàn bộ lượt, sắp xếp theo thời gian. Mọi lượt cộng dồn vào cùng một hóa đơn của phiên.
FR-CUS-07 | Yêu cầu hủy món | S | Khách hàng, Phục vụ | Nút Hủy hiện với dòng món ở CHỜ XÁC NHẬN hoặc CHỜ CÂN, khách tự hủy được (BR-03).  Bổ sung CHỜ CÂN — trước đó chỉ nhắc tới CHỜ XÁC NHẬN nên bỏ sót món bán theo cân, trong khi bảng 2.4 đã cho phép hủy tự do ở CHỜ CÂN. Từ ĐANG CHẾ BIẾN / ĐÃ PHỤC VỤ trở đi: khách chỉ có nút 'Báo nhân viên' — yêu cầu này CÓ TRẠNG THÁI (Chờ xử lý → Đã xử lý), không chỉ là thông báo một chiều. Phục vụ nhận yêu cầu và thực hiện hủy (nếu hợp lý) theo quy trình BR-24 — khai lý do, có thể cần Quản lý CN duyệt.
FR-CUS-08 | Theo dõi trạng thái món | M | Khách hàng | Hiển thị bằng ngôn ngữ khách hiểu: Đã nhận → (Đang cân, nếu là món theo cân) → Đang chế biến → Đã phục vụ.
FR-CUS-09 | Xem tạm tính | M | Khách hàng, Phục vụ, Thu ngân, QL chi nhánh | Hiển thị: từng dòng món × số lượng × đơn giá, tiền hàng, khuyến mãi, chiết khấu, phí dịch vụ, VAT, tổng cộng. Dòng món CHỜ CÂN hiển thị 'tính theo cân thật', cộng 0đ vào tổng cho tới khi có số cân. MỚI : dòng món đã hủy nhưng vẫn tính tiền (BR-24) hiển thị kèm ghi chú '[Đã hủy — vẫn tính phí]', đồng bộ cách hiển thị với FR-PAY-01. Khuyến mãi hiện rõ TÊN CHƯƠNG TRÌNH, không chỉ hiện số tiền. Công thức đúng BR-13.
FR-CUS-10 | Yêu cầu tính tiền | S | Khách hàng | Giữ mức S: bản đầu chỉ nhân viên (Phục vụ/Thu ngân) chuyển phiên sang CHỜ THANH TOÁN được; nút này của khách là mở rộng cho bản sau. Thông báo hiện ngay trên thiết bị Phục vụ của chi nhánh kèm số bàn. Chống spam: tối đa 1 yêu cầu / 60 giây. Yêu cầu tính tiền ⇒ phiên sang CHỜ THANH TOÁN, khóa gọi thêm món.

5.3. Phục vụ
ID | Chức năng | Ưu tiên | Actor | Yêu cầu chi tiết & tiêu chí nghiệm thu
FR-SRV-01 | Xem sơ đồ bàn | M | Phục vụ, Thu ngân, QL chi nhánh | Chỉ hiển thị bàn CỦA CHI NHÁNH trong ngữ cảnh (BR-18). Mỗi bàn: tên, trạng thái phiên, thời gian đã ngồi, số khách, tạm tính. Màu phân biệt: trống / đặt trước / chờ mở bàn / đang phục vụ / chờ thanh toán.  Bàn ở trạng thái ĐẶT TRƯỚC hiển thị kèm giờ hẹn và tên khách đã đặt. SỬA thuật ngữ: đổi 'chờ xác nhận' thành 'chờ mở bàn' cho đúng tên trạng thái Phiên bàn (CHỜ MỞ BÀN, Mục 2.1) — tránh nhầm với CHỜ XÁC NHẬN vốn là trạng thái của Dòng món (Mục 2.3), một khái niệm khác.
FR-SRV-02 | Mở/đóng bàn | M | Phục vụ (mở), QL chi nhánh (mở/đóng), Thu ngân (đóng) | Phục vụ hoặc QL chi nhánh xác nhận mở bàn: CHỜ MỞ BÀN → ĐANG PHỤC VỤ. Thu ngân KHÔNG được mở bàn. BẮT BUỘC nhập số lượng khách khi mở bàn. Không cho mở nếu bàn đang có phiên ĐANG PHỤC VỤ, CHỜ THANH TOÁN, hoặc ĐẶT TRƯỚC (BR-01, BR-29) — trường hợp ĐẶT TRƯỚC, hệ thống báo rõ 'Bàn đã được đặt trước lúc HH:mm', Phục vụ xác nhận nhận khách qua đúng luồng Đặt bàn trước (FR-TBL-03) thay vì mở bàn thông thường. Đóng bàn (Thu ngân hoặc QL chi nhánh) sau khi đã thu đủ tiền và phát hành hóa đơn: CHỜ THANH TOÁN → ĐÃ ĐÓNG.
FR-SRV-03 | Nhận và xác nhận order mới | M | Phục vụ, QL chi nhánh | Thông báo trực quan qua kênh real-time, chỉ nhận order của chi nhánh mình.
FR-SRV-04 | Chỉnh sửa order | M | Phục vụ, QL chi nhánh | Tăng số lượng ⇒ sinh dòng món MỚI, như order thường. Giảm số lượng / hủy khi CHỜ XÁC NHẬN hoặc CHỜ CÂN ⇒ áp đúng BR-03.  Bổ sung CHỜ CÂN, đồng bộ với FR-CUS-07 — trước đó chỉ nhắc CHỜ XÁC NHẬN, bỏ sót món bán theo cân chưa kịp cân. Hủy khi ĐANG CHẾ BIẾN / ĐÃ PHỤC VỤ ⇒ áp đúng BR-24 (khai lý do, có thể cần duyệt). Mọi chỉnh sửa ghi nhật ký (BR-12).
FR-SRV-05 | Cập nhật trạng thái chế biến | M | Phục vụ, QL chi nhánh | Khi xác nhận order (hoặc sau khi nhập số cân với món theo cân), dòng món chuyển sang ĐANG CHẾ BIẾN và hệ thống in phiếu bếp ( FR-SRV-07). Nhân viên bếp thực hiện chế biến theo phiếu bếp và không trực tiếp thao tác trên hệ thống. Khi nhận thông báo món đã hoàn thành từ bếp, Phục vụ nhận món và mang đến bàn. Sau khi mang món đến bàn, Phục vụ chuyển dòng món từ ĐANG CHẾ BIẾN sang ĐÃ PHỤC VỤ. Cho phép cập nhật từng dòng món hoặc nhiều dòng món của cùng một bàn. Mọi thay đổi trạng thái dòng món phải được ghi nhận theo BR-12.
FR-SRV-06 | Chuyển / gộp bàn | S | Phục vụ (cần duyệt), Thu ngân, QL chi nhánh | Chỉ trong PHẠM VI MỘT CHI NHÁNH. Chuyển bàn: cả phiên sang bàn đích (phải trống); bàn nguồn về trống. Giữ nguyên bộ số VAT/phí dịch vụ (BR-26). Gộp bàn: hai phiên hợp nhất, cộng dồn món, tiền, VÀ số khách (tự động, không cần nhập lại — BR-28), GIỮ NGUYÊN trạng thái từng dòng món. Phiên nguồn chuyển sang trạng thái ĐÃ GỘP (BR-28), không phải ĐÃ ĐÓNG hay ĐÃ HỦY. CHẶN gộp nếu hai phiên khác bộ số VAT/phí dịch vụ, kèm thông báo rõ lý do (BR-26). Khuyến mãi cấp hóa đơn TÍNH LẠI sau khi gộp; khuyến mãi cấp món giữ nguyên; nếu bất lợi cho khách thì giữ mức có lợi hơn (BR-25). Chiết khấu thủ công của từng phiên giữ nguyên, cộng dồn, không cần nhập lại. Ghi nhật ký kèm người thực hiện (BR-12).
 FR-SRV-07 | In phiếu bếp | M | Hệ thống (tự động), Phục vụ (in lại) | In qua máy in nhiệt nối mạng (network thermal printer) tại từng khu chế biến. Chi nhánh có nhiều khu chế biến (bếp nóng/lạnh/pha chế): phiếu tách theo khu, dựa trên field khu_che_bien của món gốc (FR-MNU-02). Nội dung phiếu: số bàn, lượt gọi thứ mấy, giờ in, tên món, số lượng, tùy chọn, ghi chú khách. KHÔNG in giá. Order lưu cờ đã_in + số_lần_in; có nút In lại; có màn hình 'Phiếu chưa in được' để Phục vụ không bỏ sót khi máy in lỗi/mất kết nối. Món hủy sau khi đã in phiếu bếp ⇒ in PHIẾU HỦY riêng gửi xuống bếp (BR-24).

5.4. Menu
ID | Chức năng | Ưu tiên | Actor | Yêu cầu chi tiết & tiêu chí nghiệm thu
FR-MNU-01 | Quản lý danh mục | M | Quản trị nhà hàng | Danh mục định nghĩa ở CẤP NHÀ HÀNG, dùng chung mọi chi nhánh. Tạo/sửa/xóa/sắp xếp; sắp thứ tự bằng kéo-thả hoặc trường số thứ tự. Không cho xóa danh mục còn món; phải chuyển món sang danh mục khác trước. Cho phép ẩn danh mục mà không xóa.
FR-MNU-02 | Quản lý Menu nhà hàng | M | Quản trị nhà hàng | Món CẤP NHÀ HÀNG. Giá ở đây là giá gốc, chi nhánh đè được. Bắt buộc: tên, danh mục, giá gốc. Trường mới: khu chế biến (khu_che_bien) — bếp nóng / bếp lạnh / pha chế..., dùng để tách phiếu bếp. Bản đầu có thể chỉ dùng một khu mặc định. Hình ảnh: tự nén và resize; giới hạn tải lên 5MB, không lưu trực tiếp ở thư mục (gợi ý lưu trên cloudinary). Món đã từng lên hóa đơn ở BẤT KỲ chi nhánh nào KHÔNG xóa, chỉ ngừng bán — xóa làm vỡ báo cáo lịch sử. Đổi giá gốc không ảnh hưởng dòng món đã gửi (BR-07) và không ghi đè giá đè của chi nhánh (BR-17).
FR-MNU-03 | Cập nhật trạng thái món | M | QL chi nhánh, Quản trị nhà hàng | Trạng thái này thuộc CHI NHÁNH. Trạng thái Còn / Hết. Actor mở rộng theo ma trận 4.2: cả QL chi nhánh và Quản trị nhà hàng đều báo hết/mở lại được. Màn hình xem toàn bộ món đang bị đánh dấu hết tại chi nhánh và mở bán lại hàng loạt.
FR-MNU-04 | Quản lý Menu chi nhánh | M | Quản trị nhà hàng, QL chi nhánh | Với mỗi món gốc, chi nhánh có thể: (a) giữ nguyên – không tạo bản giá đè; (b) đổi giá; (c) tạm ẩn không bán. Chi nhánh tạo được món RIÊNG chỉ mình bán, không xuất hiện ở chi nhánh khác. Màn hình quản lý menu chi nhánh hiện rõ: món nào theo giá gốc, món nào đã đè, chênh bao nhiêu. Xóa bản đè ⇒ món trở lại giá gốc. Món gốc bị nhà hàng ngừng bán ⇒ biến mất ở mọi chi nhánh, kể cả chi nhánh đang đè giá. Hệ thống cảnh báo TRƯỚC cho người thực hiện: số chi nhánh bị ảnh hưởng. Mọi thay đổi ghi nhật ký.
FR-MNU-05 | Quản lý nhóm tùy chọn món | M | Quản trị nhà hàng | Khai báo ở CẤP NHÀ HÀNG, dùng chung mọi chi nhánh; một nhóm dùng lại được cho nhiều món (many-to-many). Mỗi nhóm có: tên (VD 'Mức cay'), kiểu chọn (bắt buộc / không bắt buộc), giới hạn số lựa chọn (min/max). Mỗi lựa chọn trong nhóm có thể cộng thêm tiền dưới dạng SỐ TIỀN TUYỆT ĐỐI (không phải %). Bản đầu: chi nhánh KHÔNG đè được phần cộng thêm này (giữ đơn giản, đồng nhất toàn nhà hàng). Giá tùy chọn được snapshot cùng dòng món khi gửi order, theo BR-07. Món bán theo cân ĐƯỢC PHÉP gắn nhóm tùy chọn bình thường (VD: món cân + chọn mức nêm). Phần cộng thêm của tùy chọn snapshot NGAY khi gửi order (độc lập với số cân); chỉ riêng đơn giá/kg mới chờ số cân thật để tính thành tiền (BR-07). Hai phần này tính tách biệt, không phụ thuộc nhau. Bản đầu CHƯA cần trạng thái còn/hết cho từng lựa chọn riêng lẻ.

5.5. Bàn
ID | Chức năng | Ưu tiên | Actor | Yêu cầu chi tiết & tiêu chí nghiệm thu
FR-TBL-01 | Quản lý bàn | M | QL chi nhánh | Khu vực và bàn thuộc CHI NHÁNH. Mỗi bàn: tên/số bàn, khu vực, sức chứa, trạng thái hoạt động. Tên bàn và tên khu vực duy nhất TRONG CHI NHÁNH, không phải toàn hệ thống (BR-16). Không xóa bàn đang có phiên chưa đóng hoặc đã phát sinh hóa đơn (chỉ ngừng hoạt động).
FR-TBL-02 | In mã QR | M | QL chi nhánh | QR được tự động tạo khi tạo bàn, không cần thao tác riêng. In được từng bàn hoặc hàng loạt cả chi nhánh, xuất PDF khổ in sẵn kèm tên chi nhánh và tên bàn.
FR-TBL-03 | Đặt bàn trước | S | Phục vụ, QL chi nhánh | Ghi nhận giữ chỗ cho một bàn cụ thể: tên/SĐT khách, thời gian dự kiến đến, số khách dự kiến, ghi chú (nếu có). Bàn được đặt trước chuyển sang trạng thái ĐẶT TRƯỚC (Mục 2.1), chặn Quét QR và mở bàn walk-in trên bàn đó cho tới khi khách đến hoặc quá giờ giữ chỗ (BR-29). Chỉ đặt được cho bàn hiện KHÔNG có phiên nào đang mở (BR-01). Màn hình sơ đồ bàn (FR-SRV-01) hiển thị riêng màu cho bàn ĐẶT TRƯỚC, kèm giờ hẹn. Khách đến: Phục vụ xác nhận mở bàn trực tiếp từ màn hình đặt trước ⇒ chuyển ĐANG PHỤC VỤ, không cần khách quét QR trước (khách quét QR sau đó vẫn tham gia thẳng vào phiên). Khách báo không đến, hoặc quá giờ giữ chỗ cấu hình (mặc định 15 phút sau giờ hẹn): tự động hoặc thủ công chuyển ĐÃ HỦY, giải phóng bàn. Bản đầu CHƯA hỗ trợ đặt cọc, xác nhận qua SMS/Zalo tự động, hay đặt trước qua kênh khách tự thao tác (khách vẫn phải gọi điện/tới trực tiếp, nhân viên nhập hộ) — các phần này nằm ngoài phạm vi bản chạy thật đầu tiên.

5.6. Khuyến mãi
ID | Chức năng | Ưu tiên | Actor | Yêu cầu chi tiết & tiêu chí nghiệm thu
FR-PRO-01 | Quản lý chương trình khuyến mãi | M | Quản trị nhà hàng | Nâng mức ưu tiên lên M: FR-CUS-02, FR-CUS-09, FR-PAY-01 (mức M) và BR-13 đều phụ thuộc cứng vào chức năng này, nên không thể lùi. Chương trình định nghĩa ở CẤP NHÀ HÀNG, chọn chi nhánh áp dụng (một, nhiều, hoặc tất cả). Mỗi chương trình gồm: tên, mô tả hiển thị cho khách, khoảng ngày hiệu lực, khung giờ trong ngày, ngày trong tuần, chi nhánh áp dụng, trạng thái. ĐIỀU KIỆN: áp cho món cụ thể / danh mục / toàn hóa đơn; giá trị hóa đơn tối thiểu; số lượng tối thiểu. HÀNH ĐỘNG: giảm % theo món, giảm số tiền theo món, giảm % hóa đơn, giảm số tiền hóa đơn, mua X tặng Y. Mỗi chương trình phải khai rõ CẤP: cấp MÓN hay cấp HÓA ĐƠN (BR-22). Giới hạn tổng số lượt sử dụng (để trống = không giới hạn), tính CHUNG TOÀN NHÀ HÀNG cho mỗi chương trình dù áp cho một hay nhiều chi nhánh (BR-23) — cần giới hạn riêng theo từng chi nhánh thì tạo chương trình riêng; hiển thị số lượt đã dùng real-time; tự động ngừng áp khi hết lượt (BR-23). Bật/tắt tức thời, không cần chờ hết hạn. Mọi thay đổi ghi nhật ký.
FR-PRO-02 | Chiết khấu thủ công | M | Thu ngân, QL chi nhánh | Nâng mức ưu tiên lên M: đây là công cụ Thu ngân dùng hằng ngày, bản đầu không thể thiếu. Dành cho tình huống ngoài chương trình: khách quen, đền bù sự cố, quyết định tại chỗ của quản lý, hoặc miễn phí dịch vụ cho trường hợp ngoại lệ (FR-BRN-02). Chiết khấu theo % hoặc số tiền tuyệt đối; cho cả hóa đơn hoặc từng dòng món. Bắt buộc nhập lý do. Vượt ngưỡng cấu hình chi nhánh ⇒ bắt buộc Quản lý CN duyệt (BR-10). Áp SAU khuyến mãi tự động, trên phần còn lại (BR-13, BR-22). Phản ánh lên hóa đơn điện tử.

5.7. Thanh toán và hóa đơn
ID | Chức năng | Ưu tiên | Actor | Yêu cầu chi tiết & tiêu chí nghiệm thu
FR-PAY-01 | Tính tiền | M | Thu ngân, QL chi nhánh | Hiển thị: dòng món tính tiền, tiền hàng, khuyến mãi tự động (kèm tên chương trình), chiết khấu tay, phí dịch vụ, VAT, tổng cộng. Cảnh báo nếu phiên còn món ĐANG CHẾ BIẾN hoặc còn món CHƯA PHỤC VỤ. CHẶN tính tiền/phát hành hóa đơn nếu còn dòng món ở trạng thái CHỜ CÂN  Khuyến mãi CẤP HÓA ĐƠN được kiểm tra và trừ lượt sử dụng (BR-23) NGAY tại bước này. Nếu vừa hết lượt đúng lúc chốt bàn, tự động bỏ áp dụng và tính lại theo giá gốc — không cần Thu ngân/khách xác nhận riêng vì đây là bước nội bộ của Thu ngân, không phải bước khách gửi order. Dòng món đã hủy sau khi vào bếp nhưng VẪN TÍNH TIỀN (BR-24, lý do 'Khách đổi ý') hiển thị RIÊNG một dòng có ghi chú '[Đã hủy — vẫn tính phí]' kèm lý do, để khách đọc hóa đơn/tạm tính không thắc mắc tại sao món đã hủy còn xuất hiện trong tổng tiền. Dòng hủy 'Lỗi nhà hàng — không tính tiền' KHÔNG xuất hiện trong tổng tiền. In được phiếu tạm tính trước khi thu tiền.
FR-PAY-02 | Thanh toán tiền mặt | M | Thu ngân, QL chi nhánh | Nhập số tiền khách đưa, hệ thống tính tiền thối. Ghi nhận phương thức 'Tiền mặt'.
FR-PAY-03 | Thanh toán chuyển khoản QR | M | Thu ngân, QL chi nhánh | Mỗi chi nhánh dùng TÀI KHOẢN NGÂN HÀNG RIÊNG, cấu hình tại FR-BRN-02. Sinh QR ĐỘNG (chuẩn VietQR) chứa sẵn số tiền và nội dung chuyển khoản. Thao tác xác nhận thủ công này BẮT BUỘC ghi nhật ký theo BR-12 (người xác nhận, thời điểm, số tiền, phiên/hóa đơn liên quan) — vì đây là điểm rủi ro gian lận cao nhất trong quy trình thanh toán. QR hết hiệu lực khi phiên đóng.
FR-PAY-04 | Phát hành hóa đơn điện tử | M | Thu ngân, QL chi nhánh | Phát hành hóa đơn điện tử khởi tạo từ máy tính tiền, kết nối dữ liệu với cơ quan thuế. ⚠ Nhà cung cấp hóa đơn điện tử CHƯA CHỐT — thiết kế một lớp adapter/interface (InvoiceProvider) để cắm nhà cung cấp bất kỳ mà không đổi schema. Mã số thuế lấy theo BR-20. Số hóa đơn đánh riêng theo chi nhánh (BR-19). Phát hành THẤT BẠI ⇒ CHẶN đóng bàn (giữ nguyên bảng 2.2: điều kiện 'hóa đơn phát hành xong' mới sang ĐÃ ĐÓNG); Thu ngân được thử phát hành lại nhiều lần trên cùng phiên CHỜ THANH TOÁN. Thành công ⇒ lưu số hóa đơn. Có thể in hóa đơn. Thanh toán hỗn hợp (FR-PAY-05) ⇒ trường 'phương thức thanh toán' trên hóa đơn ghi 'Hỗn hợp'; hệ thống lưu kèm breakdown chi tiết từng khoản (nội bộ, tra cứu được) — nếu nhà cung cấp hóa đơn điện tử hỗ trợ hiển thị breakdown trên chứng từ thì hiển thị, không thì chỉ hiện tổng 'Hỗn hợp' trên hóa đơn và breakdown xem trong hệ thống.
FR-PAY-05 | Thanh toán hỗn hợp | M | Thu ngân, QL chi nhánh | Áp dụng khi một hóa đơn được thanh toán bằng NHIỀU HƠN MỘT phương thức — bản đầu chỉ hỗ trợ đúng 2 phương thức kết hợp: TIỀN MẶT + CHUYỂN KHOẢN (không hỗ trợ nhiều lần chuyển khoản khác tài khoản hay nhiều thẻ khác nhau trong cùng 1 hóa đơn). Thu ngân bật chế độ 'Thanh toán hỗn hợp' trên màn hình tính tiền (FR-PAY-01), nhập số tiền cho TỪNG phương thức riêng biệt — hệ thống tự tính phần còn lại của phương thức kia dựa trên tổng phải thu, hoặc Thu ngân tự nhập cả hai; hệ thống CHẶN xác nhận nếu tổng hai khoản KHÔNG BẰNG tổng phải thu. Mỗi khoản (tiền mặt / chuyển khoản) lưu thành MỘT BẢN GHI THANH TOÁN (payment) riêng — gồm phương thức, số tiền, thời điểm, người xác nhận — KHÔNG gộp chung một dòng, để phục vụ đối soát và báo cáo chính xác theo từng phương thức (FR-RPT-01). Phần tiền mặt: áp đúng quy trình FR-PAY-02 (nhập tiền khách đưa cho riêng phần này, tính tiền thối nếu khách đưa dư — tiền thối chỉ tính trên phần tiền mặt, không liên quan phần chuyển khoản). Phần chuyển khoản: áp đúng quy trình FR-PAY-03 (sinh QR động với ĐÚNG số tiền của phần chuyển khoản — không phải tổng hóa đơn — và nội dung chuyển khoản; Thu ngân xác nhận thủ công sau khi kiểm tra app ngân hàng). Chỉ cho phát hành hóa đơn (FR-PAY-04) khi TẤT CẢ các khoản đã được xác nhận đủ (tiền mặt đã nhận, chuyển khoản đã xác nhận). Ghi nhật ký riêng cho từng khoản theo BR-12 (đồng bộ yêu cầu ghi nhật ký của FR-PAY-03 cho phần chuyển khoản trong tổ hợp hỗn hợp). Sai sót giữa các khoản sau khi hóa đơn đã phát hành: xử lý bằng hóa đơn điều chỉnh/thay thế (BR-09), không sửa trực tiếp bản ghi thanh toán cũ.

5.8. Báo cáo
ID | Chức năng | Ưu tiên | Actor | Yêu cầu chi tiết & tiêu chí nghiệm thu
FR-RPT-01 | Xem doanh thu ngày/tháng/năm | M | QL chi nhánh, Quản trị nhà hàng | Chỉ số: tổng doanh thu, số hóa đơn, số khách (dựa trên số khách bắt buộc nhập khi mở bàn —, giá trị trung bình/hóa đơn, chi tiết theo phương thức thanh toán. Chi tiết theo phương thức thanh toán tính theo TỪNG BẢN GHI THANH TOÁN (payment, FR-PAY-05), không theo hóa đơn — một hóa đơn thanh toán hỗn hợp đóng góp số tiền vào CẢ HAI dòng 'Tiền mặt' và 'Chuyển khoản' tương ứng đúng số tiền thực của từng phần, không quy toàn bộ hóa đơn về một phương thức. Biểu đồ xu hướng theo kỳ. So sánh với kỳ liền trước. Bộ lọc chi nhánh; chọn nhiều chi nhánh thì cộng dồn.
FR-RPT-02 | Xem doanh thu theo khung giờ | S | QL chi nhánh, Quản trị nhà hàng | Phân bổ doanh thu và số bàn theo từng khung giờ trong ngày. So sánh theo ngày trong tuần. Lọc theo chi nhánh.
FR-RPT-03 | Xem thống kê món bán chạy / bán chậm | S | QL chi nhánh, Quản trị nhà hàng | Hai bảng xếp hạng RIÊNG: theo số lượng bán và theo doanh thu. Lọc theo danh mục và chi nhánh. Danh sách món bán chậm nhất, để cân nhắc loại khỏi menu.
FR-RPT-04 | So sánh doanh thu chi nhánh | S | Quản trị nhà hàng | Bảng xếp hạng chi nhánh theo doanh thu, số hóa đơn, giá trị trung bình/hóa đơn, tỷ lệ hủy món. Tỷ lệ hủy món nay tách theo 2 loại nhờ BR-24: hủy 'lỗi nhà hàng' và hủy 'khách đổi ý' — phản ánh đúng bản chất vận hành thay vì gộp chung. Cảnh báo chi nhánh có chỉ số lệch bất thường so với trung bình.
FR-RPT-05 | Xuất báo cáo | S | QL chi nhánh, Quản trị nhà hàng | Xuất .xlsx và .csv, mã hóa UTF-8, hiển thị đúng tiếng Việt có dấu. Giữ nguyên bộ lọc đang áp trên màn hình.

5.9. Quản trị nhà hàng
ID | Chức năng | Ưu tiên | Actor | Yêu cầu chi tiết & tiêu chí nghiệm thu
FR-ADM-01 | Quản lý nhân viên | M | Quản trị nhà hàng | Tài khoản thuộc CẤP NHÀ HÀNG. Mỗi tài khoản: họ tên, mã nhân viên, tên đăng nhập, email (TÙY CHỌN), trạng thái. Tên đăng nhập duy nhất trong phạm vi nhà hàng, không phải toàn nền tảng. KHÔNG xóa cứng tài khoản đã phát sinh giao dịch — chỉ vô hiệu hóa, giữ truy vết. Đặt lại mật khẩu ⇒ buộc đổi ở lần đăng nhập kế tiếp. Tài khoản không có email: Quản trị nhà hàng đặt lại hộ.
FR-ADM-02 | Vai trò và phân quyền | M | Quản trị nhà hàng | 6 vai trò mặc định (Mục 4.1), tạo sẵn khi khởi tạo nhà hàng. Mỗi vai trò có PHẠM VI: nhà hàng, hay chi nhánh. Chỉnh được quyền của từng vai trò ở mức chức năng, trong phạm vi nhà hàng mình.
FR-ADM-03 | Cấu hình nhà hàng | M | Quản trị nhà hàng | Thông tin công ty: tên, mã số thuế, địa chỉ, điện thoại, logo (in lên hóa đơn).
FR-ADM-04 | Đăng nhập & đăng xuất | M | Tất cả nhân viên | Đăng nhập bằng TÊN ĐĂNG NHẬP. Màn hình đăng nhập yêu cầu nhập kèm MÃ NHÀ HÀNG để hệ thống xác định đúng tenant. Mỗi thiết bị/máy tính tiền của chi nhánh lưu sẵn MÃ NHÀ HÀNG MẶC ĐỊNH (cấu hình một lần khi setup máy lần đầu, lưu cục bộ trên thiết bị). Từ lần sau, nhân viên chỉ cần nhập tên đăng nhập + mật khẩu; trường mã nhà hàng tự điền sẵn nhưng vẫn sửa được (trường hợp máy dùng chung cho nhiều nhà hàng). Sai thông tin ⇒ báo lỗi chung, không tiết lộ tài khoản có tồn tại hay không. Lần đầu đăng nhập ⇒ buộc đổi mật khẩu trước khi vào hệ thống. Ghi nhật ký: thời điểm, thành công hay thất bại. Quên mật khẩu: CHỈ áp dụng cho tài khoản có khai email — gửi link reset, hợp lệ 30 phút, dùng một lần. Tài khoản không có email: nhờ Quản trị nhà hàng đặt lại hộ. Link hết hạn hoặc đã dùng ⇒ báo rõ, cho phép gửi lại. Nhân viên có nhiều phân công chi nhánh: chọn chi nhánh làm việc ngay sau khi đăng nhập, đổi được bất kỳ lúc nào qua thanh trên cùng. Đăng xuất ⇒ hủy phiên ngay lập tức, chuyển về màn hình đăng nhập. Ghi nhật ký đăng xuất.

5.10. Quản trị hệ thống
ID | Chức năng | Ưu tiên | Actor | Yêu cầu chi tiết & tiêu chí nghiệm thu
FR-TEN-01 | Quản lý nhà hàng | M | Quản trị nền tảng | Tạo/sửa/ngừng nhà hàng. Mỗi nhà hàng có: mã, tên, mã số thuế. Mã nhà hàng duy nhất toàn hệ thống, KHÔNG sửa được sau khi đã phát sinh hóa đơn.

5.11. Nhật ký hoạt động 
ID | Chức năng | Ưu tiên | Actor | Yêu cầu chi tiết & tiêu chí nghiệm thu
FR-LOG-01 | Xem nhật ký hoạt động | M | QL chi nhánh (chi nhánh mình), Quản trị nhà hàng (toàn bộ) | Có màn hình xem trong bản đầu — công cụ vận hành hằng ngày, không chỉ để tra cứu khi có sự cố. Một nhật ký CHUNG cho mọi loại hành động: đổi tiền/trạng thái dòng món (BR-12), đổi trạng thái phiên bàn (mở/hủy/gộp/tách), đăng nhập/xuất, đổi giá món, tạo/vô hiệu hóa nhân viên, sửa cấu hình chi nhánh, hủy phiên — không tách nhiều bảng log riêng lẻ. Bộ lọc: khoảng thời gian, chi nhánh, người thực hiện, loại hành động. Xuất được .xlsx. Lưu tối thiểu 5 năm với các bản ghi liên quan tới tiền (phù hợp thông lệ lưu trữ chứng từ kế toán). Các bản ghi KHÔNG liên quan tới tiền (đăng nhập/xuất, đổi giờ giấc, đổi thông tin nhân viên...) lưu tối thiểu 2 năm, sau đó có thể archive hoặc xóa theo chính sách vận hành — tránh phình dữ liệu vô thời hạn trong khi vẫn đủ để tra cứu sự cố gần đây. Quản lý CN chỉ xem nhật ký chi nhánh mình (BR-18); Quản trị nhà hàng xem toàn bộ nhà hàng.

6. RÀNG BUỘC KỸ THUẬT
# | Ràng buộc
T-01 | Cập nhật gần-tức-thời cho các luồng bắt buộc real-time (thông báo order mới cho Phục vụ, theo dõi trạng thái món cho khách, yêu cầu tính tiền): độ trễ chấp nhận được ≤ 5 giây. Dùng WebSocket cho các luồng này, không dùng polling.
T-02 | Cách ly dữ liệu nhà hàng (BR-21) triển khai ở tầng ứng dụng: một CSDL dùng chung, restaurant_id bắt buộc trên mọi bảng nghiệp vụ, khóa ngoại tổ hợp, một lớp chặn duy nhất ở tầng truy cập dữ liệu.
T-03 | Ngoại tuyến (toàn chi nhánh): KHÔNG bắt buộc chạy offline ở bản đầu. Mất mạng ⇒ dừng nhận order mới, nhưng bắt buộc có cơ chế cảnh báo rõ ràng cho nhân viên (không được để hệ thống 'đơ' âm thầm).
T-04 | Thiết bị nhân viên: điện thoại / máy tính bảng, truy cập qua trình duyệt (web app). Không hỗ trợ trình duyệt phát hành quá 2 năm.
T-05 | Quy mô hệ thống (số nhà hàng, số chi nhánh/nhà hàng, số bàn/chi nhánh, số order/phút giờ cao điểm): CHƯA CHỐT — cần chủ dự án cung cấp số liệu thực tế để tính toán sizing hạ tầng.
T-06 | Sao lưu & phục hồi: CHƯA CHỐT đầy đủ — cần xác định RPO/RTO cụ thể trước khi lên kiến trúc triển khai.
T-07 | Ngoại tuyến (một thiết bị đơn lẻ): khi kết nối WebSocket của MỘT thiết bị bị rớt (khác với mất mạng toàn chi nhánh ở T-03), thiết bị đó phải tự động thử kết nối lại theo chu kỳ backoff (ví dụ 2s → 5s → 10s...) và hiển thị banner 'Mất kết nối — đang thử lại' cho tới khi khôi phục. Không chặn thao tác cục bộ (xem menu, chọn món) trong lúc chờ kết nối lại, chỉ chặn gửi order.
T-08 | Tần suất chạy các tiến trình nền (scheduled job): job reset Hết hàng → Còn hàng (BR-06), job tự hủy phiên CHỜ MỞ BÀN (BR-27), và job tự hủy phiên ĐẶT TRƯỚC quá giờ giữ chỗ (BR-29) chạy tối thiểu mỗi 1 phút. Độ trễ giữa thời điểm lý thuyết hết hạn và lúc job xử lý thực tế chấp nhận được ≤ 1 phút.
T-09 | Rủi ro khóa xuyên chi nhánh: vì quota khuyến mãi tính CHUNG TOÀN NHÀ HÀNG (BR-23) thay vì theo từng chi nhánh, việc trừ lượt sử dụng có thể cần khóa (lock) một bản ghi dùng chung giữa nhiều chi nhánh của cùng nhà hàng tại cùng thời điểm — khác với phần lớn thao tác còn lại của hệ thống vốn chỉ chạm dữ liệu trong phạm vi 1 chi nhánh (BR-18). Đây là điểm nóng hiệu năng tiềm ẩn ở chuỗi nhà hàng nhiều chi nhánh vào giờ cao điểm; cần đội kỹ thuật đánh giá riêng khi thiết kế bảng đếm lượt khuyến mãi (ví dụ dùng cơ chế đếm lạc quan/optimistic lock hoặc hàng đợi thay vì khóa bi quan/pessimistic lock).


