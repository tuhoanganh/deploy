## OpenCPS deploy  

## Giới thiệu
* OpenCPS deploy áp dụng các công nghệ mới để triển khai ứng dụng OpenCPS, với mục đích tự động hóa việc triển khai cho việc sử dụng và kiểm thử. Với một số các công việc cần phải làm:  
 * Xây dựng qui trình triển khai hệ thống OpenCPS  
 * Xây dựng giải pháp đảm bảo an ninh, an toàn, bảo mật cho OpenCPS  
 * Xây dựng giải pháp đảm bảo sẵn sàng hệ thống  
 * Xây dựng giải pháp scale hệ thống  
 * Xây dựng giải pháp monitor hệ thống  
* Các công nghệ được sử dụng  
 * Docker   
 * Ansible  
 * Mariadb  
 * ...

##  Một số công việc đã và đang thực hiện  
### I. Triển khai OpenCPS trên Server vật lý  
##### 1. Cài đặt MariaDB Master Slave  
 * Chi tiết tại thư mục	opencps-mariadb-master-slave
 
 > https://github.com/VietOpenCPS/deploy/tree/master/opencps-mariadb-master-slave   

##### 2. Triển khai ứng dụng OpenCPS  

### II. Triển khai OpenCPS trên Docker
#### 1. Quy trình đóng gói, hướng dẫn triển khai ứng dụng OpenCPS sử dụng Docker images  
* Thông tin đóng gói nằm trong thư mục dockerize: 

 > https://github.com/VietOpenCPS/deploy/tree/master/opencps-dockerize  

* Hiện tại, sẽ có 2 cách triển khai ứng dụng OpenCPS trên Docker:
 * Triển khai ứng dụng OpenCPS bằng Docker theo mô hình một container: Cả ứng dụng và database chạy trên cùng một container.  
 * Triển khai ứng dụng OpenCPS bằng Docker theo mô hình hai container: Ứng dụng và database chạy trên hai container khác nhau.  

#### 1.1. Triển khai ứng dụng OpenCPS bằng Docker theo mô hình 2 container  
 * Chi tiết tại thư mục dockerize-all-in-one-container
 
 > https://github.com/VietOpenCPS/deploy/tree/master/opencps-dockerize/dockerize-all-in-one-container     

#### 1.2.  Triển khai ứng dụng OpenCPS bằng Docker theo mô hình 2 containerTriển khai ứng dụng OpenCPS bằng Docker theo mô hình 2 container  
 * Chi tiết tại thư mục	dockerize-all-in-two-containers
 
 > https://github.com/VietOpenCPS/deploy/tree/master/opencps-dockerize/dockerize-all-in-two-containers  
 
### 2. Triển khai Database Cluster (MariaDB Galera) sử dụng Docker Swarm  
 * Chi tiết tại thư mục Mariadb-Galera-Centos7-Docker-Swarm
 
 > https://github.com/VietOpenCPS/deploy/tree/master/opencps-mariadb-galera-centos7-dockerswarm  

### Giấy phép
* OpenCPS được phát hành theo giấy phép GNU Affero General Public License v3+.
* Xem toàn văn giấy phép trong tệp [LICENSE](LICENSE)
