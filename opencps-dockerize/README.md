# Dockerize OpenCPS  
* Dự án OpenCPS áp dụng công nghệ Docker. Ứng dụng OpenCPS được đóng gói trong Docker Image, sau đó được lưu trữ trên Docker hub nhằm mục đích để mọi người có thể chạy được bản đóng gói OpenCPS mới nhất trên máy tính của mình 
* Các version của images được xác định bởi các tag, mặc định version của image là "latest"  
* Để sử dụng image OpenCPS mới nhất mọi người sẽ download image về và sử dụng theo hướng dẫn  

### Version hiện tại của ứng dụng:  
* Version OpenCPS v1.0   

### Các thành phần đóng gói:  
* Ứng dụng OpenCPS
* Java 1.7  
* Liferay (Bundle with tomcat 7) đã được đóng gói, tích hợp sẵn Tomcat và dữ liệu mẫu của bản OpenCPS v1.0
* Mariadb 10  

### Các tính năng chính:  

# Hướng dẫn triển khai Offline 
* Có 2 cách để triển khai ứng dụng Offline, mọi người có thể tham khảo:
  * Triển khai ứng dụng OpenCPS bằng Docker theo mô hình All-in-one, tất cả được đóng gói trong một container  (ứng dụng, Database)
    * Thông tin chi tiết mọi người có thể tham khảo tại đường dẫn Wiki:  
    [Wiki: Quy trình triển khai Offline cho người dùng cuối theo mô hình một container all-in-one](https://github.com/VietOpenCPS/deploy/wiki/H%C6%B0%E1%BB%9Bng-d%E1%BA%ABn-tri%E1%BB%83n-khai-%E1%BB%A9ng-d%E1%BB%A5ng-OpenCPS-Offline-cho-ng%C6%B0%E1%BB%9Di-d%C3%B9ng-theo-m%C3%B4-h%C3%ACnh-all-in-one,-t%E1%BA%A5t-c%E1%BA%A3-%C4%91%C3%B3ng-g%C3%B3i-trong-m%E1%BB%99t-container)  
  * Triển khai ứng dụng OpenCPS bằng Docker theo mô hình chạy 2 container  (ứng dụng và database trên các container khác nhau)
    * Thông tin chi tiết mọi người có thể tham khảo tại đường dẫn Wiki:  
    [Wiki: Quy trình triển khai Offline cho người dùng cuối theo mô hình chạy 2 container](https://github.com/VietOpenCPS/deploy/wiki/H%C6%B0%E1%BB%9Bng-d%E1%BA%ABn-tri%E1%BB%83n-khai-%E1%BB%A9ng-d%E1%BB%A5ng-OpenCPS-Offline-cho-ng%C6%B0%E1%BB%9Di-d%C3%B9ng-m%C3%B4-h%C3%ACnh-ch%E1%BA%A1y-2-container)  

# Hướng dẫn đóng gói ứng dụng OpenCPS sử dụng Docker image cho người phát triển (Developer)  
* Thông tin chi tiết về quy trình đóng gói ứng dụng OpenCPS, mọi người có thể tham khảo tại đường dẫn Wiki:
  * [Wiki: Quy trình đóng gói ứng dụng cho nhà phát triển](https://github.com/VietOpenCPS/deploy/wiki/H%C6%B0%E1%BB%9Bng-d%E1%BA%ABn-quy-tr%C3%ACnh-%C4%91%C3%B3ng-g%C3%B3i-Docker-image-cho-nh%C3%A0-ph%C3%A1t-tri%E1%BB%83n-%28Developer%29)
