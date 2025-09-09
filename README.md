# Hello World HTML di EC2 via Terraform

## 📖 Deskripsi
Proyek ini menunjukkan bagaimana melakukan otomatisasi deployment sederhana menggunakan **Terraform** ke **AWS EC2**. Instance EC2 akan otomatis dibuat, dipasang web server Apache (`httpd`), menarik kode HTML dari repository Git, dan menampilkannya di browser. Selain itu, integrasi dengan **GitHub Actions** memungkinkan update otomatis ketika ada perubahan di branch `main`.

## 📑 Daftar Isi
- [Deskripsi](#-deskripsi)
- [Instalasi](#-instalasi)
- [Penggunaan](#-penggunaan)
- [Fitur](#-fitur)
- [Konfigurasi](#-konfigurasi)

## ⚙️ Instalasi
1. **Kloning repository**
   ```bash
   git clone https://github.com/orgbelajar/build-dutomation-deployment-EC2-using-terraform.git
   cd build-dutomation-deployment-EC2-using-terraform
   ```

2. **Konfigurasi AWS CLI**
   Jalankan:

   ```bash
   aws configure
   ```

   Masukkan:
   
   * `AWS_ACCESS_KEY_ID`
   * `AWS_SECRET_ACCESS_KEY`
   * `Default region name` (misalnya `us-west-2`)
   * `Default output format` (`json` disarankan)

   ⚠️ **Catatan Penting (Temporary Credentials)**
   
   Jika kamu menggunakan **Temporary AWS Credentials** (misalnya dari IAM Role, SSO, atau STS), selain `AWS_ACCESS_KEY_ID` dan `AWS_SECRET_ACCESS_KEY`, biasanya diberikan juga **`AWS_SESSION_TOKEN`**.

   Jika token ini tidak ditambahkan, Terraform akan gagal dengan error:

   ```
   The security token included in the request is invalid
   ```

   **Solusi**: Tambahkan `aws_session_token` secara manual ke dalam file `~/.aws/credentials`, contohnya:

   ```
   [default]
   aws_access_key_id = ASIAEXAMPLE123
   aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
   aws_session_token = IQoJb3JpZ2luX2VjEOr//////////wEaCXVzLXdlc3QtMiJ...
   ```
   
   Dengan begitu, Terraform akan bisa melakukan autentikasi dengan benar menggunakan temporary credentials.

4. **Inisialisasi Terraform**

   ```bash
   terraform init
   ```

5. **Sesuaikan variabel**
   Ubah nilai pada `variables.tf` sesuai kebutuhan, misalnya:

   * `aws_region`
   * `instance_type`
   * `ssh_key_public_path`
   * `ssh_ingress_cidr`
   * `repo_url`

## ▶️ Penggunaan

1. **Deploy Infrastruktur**

   ```bash
   terraform apply -auto-approve
   ```

2. **Ambil Output**
   Terraform akan memberikan **Public IP EC2**.
   Buka di browser:

   ```
   http://<public_ip>
   ```

   Maka halaman `Hello World` akan muncul.

3. **Update Konten (Bonus dengan GitHub Actions)**

   * Edit file `test.html`
   * Push ke branch `main`
   * Server akan otomatis menarik update terbaru dan menyajikan halaman baru (misalnya "Hello World 2").

## ✨ Fitur

* Infrastruktur otomatis dengan Terraform
* EC2 dilengkapi Apache (`httpd`) dan Git
* Security Group dengan aturan HTTP (80) terbuka dan SSH (22) terbatas
* Auto-deploy HTML ke `index.html`
* Bonus: CI/CD dengan GitHub Actions

## 🔧 Konfigurasi

* **Terraform Files**

  * `versions.tf` → Mendefinisikan versi Terraform dan provider
  * `variables.tf` → Variabel seperti `region`, `instance_type`, dan `repo_url`
  * `main.tf` → Resource utama (EC2, Security Group, Key Pair)
  * `outputs.tf` → Menampilkan hasil, seperti Public IP EC2
* **GitHub Secrets (untuk Actions)**

  * `EC2_HOST` → Public IP EC2
  * `EC2_USER` → Username (misal `ec2-user`)
  * `EC2_KEY` → Private key SSH