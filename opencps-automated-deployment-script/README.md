## OpenCPS deploy  

## Giới thiệu
* Sau một thời gian phát triển, nhận thấy rằng việc deploy từ Source Code OpenCPS hiện tại đang còn trải qua khá nhiều công đoạn phức tạp. Khiến cho người sử dụng gặp khó khoăn khi
tiếp cận với các bản Release mới. Vì vậy Team Deploy của OpenCPS đã tự động hóa quy trình deploy OpenCPS bằng các Bash Script.
Các bước triển khai bằng Script bao gồm các bước sau:
 * Tải Liferay Bundle with Jboss 6.2.5GA6   
 * Build file deploy từ source code tự động bằng Script
 * Cài đặt và Import Cơ sở dữ liệu   
 * Cấu hình và Start OpenCPS  

### Giấy phép
* OpenCPS được phát hành theo giấy phép GNU Affero General Public License v3+.
* Xem toàn văn giấy phép trong tệp [LICENSE](LICENSE)
