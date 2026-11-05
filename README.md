# Block-WPS-Services

## Giới thiệu

File [Block WPS Junk Services.bat](Block%20WPS%20Junk%20Services.bat) là một script batch cho Windows dùng để ngăn chặn các dịch vụ nền, cập nhật tự động và quảng cáo của WPS Office.

Script này chủ yếu nhằm:
- đóng các tiến trình WPS đang chạy ngầm,
- vô hiệu hóa các dịch vụ liên quan,
- xóa các task cập nhật trong Task Scheduler,
- gỡ bỏ mục khởi động cùng Windows,
- chặn kết nối mạng của các file chạy ngầm qua Windows Firewall.

## Mục tiêu

WPS Office đôi khi tích hợp các tính năng như:
- cập nhật tự động,
- dịch vụ nền,
- nhắc quảng cáo,
- telemetry hoặc các hoạt động không cần thiết khi khởi động máy.

Script này giúp loại bỏ những yếu tố đó để giảm tệ nạn quảng cáo và hoạt động nền không mong muốn.

## Cách hoạt động

Khi chạy file .bat, script sẽ thực hiện các bước chính sau:

1. Kiểm tra quyền Administrator
   - Nếu chưa có quyền admin, script sẽ tự động yêu cầu chạy với quyền quản trị.

2. Kết thúc tiến trình WPS đang chạy
   - Tắt các tiến trình như wps.exe, et.exe, wpp.exe, wpspdf.exe, wpscloudsvr.exe, wpsupdate.exe, ...

3. Vô hiệu hóa dịch vụ WPS
   - Dừng và tắt các dịch vụ có liên quan đến WPS Office và cập nhật.

4. Xóa task tự động trong Task Scheduler
   - Tìm và xóa các task do WPS hoặc Kingsoft tạo ra.

5. Xóa khởi động cùng Windows
   - Xóa các mục đăng ký startup trong Registry để tránh WPS tự chạy khi bật máy.

6. Chặn các kết nối quảng cáo/telemetry qua Firewall
   - Tạo rule trên Windows Firewall để chặn việc các file WPS gửi hoặc nhận dữ liệu nền.
   - Có thể áp dụng thêm hạn chế quyền truy cập cho các file như wpsupdate.exe, wpsnotify.exe, wpscloudsvr.exe.

## Lưu ý

- Script chỉ hoạt động trên hệ điều hành Windows.
- Cần chạy với quyền Administrator.
- Việc chặn các dịch vụ và tệp cập nhật của WPS có thể khiến phần mềm ngừng tự cập nhật hoặc các tính năng nền không hoạt động.
- Đây là công cụ mang tính can thiệp hệ thống, nên hãy sử dụng cẩn thận và chỉ khi bạn hiểu rõ tác động.

## Cách sử dụng

1. Mở file [Block WPS Junk Services.bat](Block%20WPS%20Junk%20Services.bat).
2. Chấp nhận quyền quản trị nếu Windows yêu cầu.
3. Chờ script thực hiện tất cả các bước.
4. Sau khi hoàn tất, nhấn phím bất kỳ để đóng cửa sổ.

## Ghi chú

Đây là một script tiện ích dành cho mục đích giảm thiểu hoạt động nền và quảng cáo của WPS Office. Nếu bạn cần, có thể tùy chỉnh lại danh sách tiến trình, dịch vụ và file cần chặn theo nhu cầu cá nhân.