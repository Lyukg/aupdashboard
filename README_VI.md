# AUP Marketing — Bộ triển khai

## Thành phần

- web/index.html — dashboard mới nhất, bao gồm các chỉnh sửa theo comment.
- web/config.js — cấu hình kết nối Supabase.
- supabase/01_setup.sql — tạo bảng, phân quyền và workspace trống với 5 segment.
- supabase/02_add_member.sql — cấp vai trò admin hoặc marketing cho tài khoản.

## Triển khai lần đầu

1. Tạo project tại https://supabase.com/dashboard. Giữ mật khẩu database trong nơi lưu mật khẩu của bạn.
2. Trong SQL Editor của project mới, chạy toàn bộ 01_setup.sql. Workspace ban đầu chưa chứa dữ liệu nhập. Các mục tiêu kế hoạch lấy từ bản dashboard và có thể chỉnh lại.
3. Trong Authentication > Users, tạo tài khoản bằng email và mật khẩu. Tài khoản cần được xác nhận email trước khi đăng nhập. Bản web dùng đăng nhập email/mật khẩu.
4. Mở 02_add_member.sql, thay REPLACE_WITH_TEAM_EMAIL bằng email vừa tạo. Dùng admin cho người quản trị hoặc marketing cho thành viên. Chạy SQL và lặp lại cho từng người.
5. Trong web/config.js, thay YOUR_SUPABASE_PROJECT_URL và YOUR_SUPABASE_PUBLISHABLE_KEY bằng Project URL và publishable key của project. Tên trường supabaseAnonKey được giữ để tương thích với dashboard. Giữ nguyên workspaceId vì nó khớp với SQL. Secret key và service_role key phải được giữ ở máy chủ.
6. Đăng nhập Netlify rồi kéo thư mục web vào vùng triển khai thủ công. Thư mục được tải lên cần có index.html và config.js ngay ở cấp đầu. Netlify cấp một URL HTTPS để mở web. Hướng dẫn chính thức https://docs.netlify.com/deploy/create-deploys/
7. Mở URL, đăng nhập bằng tài khoản đã cấp quyền. Chọn Workspace khi muốn lưu dữ liệu chung.
8. Nhập một KPI thử. Chờ trạng thái “Đã đồng bộ với Supabase”. Tải lại trang và kiểm tra số còn lưu. Đăng nhập bằng một thành viên khác để kiểm tra quyền truy cập và dữ liệu chung.
9. Thử CSV, XLSX và export trên dữ liệu của bạn trước khi team sử dụng chính thức.

## Chuyển dữ liệu đang có trên máy

Trên bản cũ, xuất Backup JSON của Workspace và cất bản sao. Sau khi đăng nhập bản online, dùng chức năng nhập Backup JSON trong mục dữ liệu để khôi phục vào workspace cloud, rồi chờ trạng thái đồng bộ thành công. Thao tác khôi phục thay thế trạng thái hiện tại của workspace, nên thực hiện lúc khởi tạo hoặc khi các thành viên đã thống nhất.

Demo có vùng lưu riêng trong trình duyệt. Luồng nhận diện Meta CSV và LinkedIn Personal của bản hiện tại vẫn đưa file native vào Demo. Dữ liệu đó chưa tự chuyển sang Workspace. Khi sử dụng dữ liệu thật, cần kiểm tra nguồn tài khoản và chọn luồng nhập phù hợp trước khi xem là dữ liệu chung của team.

## Phân quyền và đồng bộ

Admin và Marketing đều được đọc, chỉnh số liệu trong workspace được cấp. Danh sách thành viên được quản lý bằng Supabase Dashboard/SQL Editor. Người dùng web chỉ đọc được dòng membership của chính mình, không tự cấp quyền qua web.

Bản này lưu toàn bộ trạng thái dashboard trong một bản ghi JSON. Khi hai người lưu cùng một phiên bản, web báo xung đột để tránh ghi đè. Xuất backup phần đang sửa, tải lại bản cloud rồi nhập lại phần thay đổi. Dữ liệu được đọc khi đăng nhập/tải lại trang, chưa có cập nhật Realtime giữa các máy.

Nếu hiện “CHƯA ĐỒNG BỘ”, xuất Backup JSON trước khi đóng trang, kiểm tra kết nối và quyền thành viên. Chỉ xem là đã lưu cloud khi có trạng thái đồng bộ thành công.

## Cập nhật web sau này

Chỉnh index.html và giữ cấu hình project đang dùng. Tải thư mục web mới vào vùng deploy của cùng site Netlify để giữ URL. Thay đổi giao diện thông thường không cần chạy lại SQL. 01_setup.sql có cơ chế giữ dữ liệu workspace đã tồn tại, nhưng cần kiểm tra riêng nếu thay đổi cấu trúc database trong tương lai.

## Trạng thái kiểm tra

Đã kiểm tra cú pháp JavaScript, dữ liệu khởi tạo, các phép tính KPI, CSV round-trip và nội dung gói. Chưa chạy SQL trên một project Supabase thực tế, chưa kiểm thử đăng nhập/RLS/đồng bộ qua mạng và chưa triển khai hosting. Cần hoàn tất bước kiểm thử thực tế ở trên trước khi sử dụng chung.

Tài liệu API keys https://supabase.com/docs/guides/getting-started/api-keys
Tài liệu RLS https://supabase.com/docs/guides/database/postgres/row-level-security
