# Hello World HTML on EC2 via Terraform

## Tujuan

- Deploy EC2 otomatis dengan Security Group
- Pasang httpd, clone repo Git, sajikan `test.html` sebagai `index.html`
- Keluarkan Public IP sebagai output Terraform
- Bonus: Auto-update via GitHub Actions saat push ke `main`

## Langkah Cepat

1. `terraform init`
2. `terraform apply -auto-approve`
3. Buka `http://<public_ip>` → menampilkan "Hello World"
4. (Bonus) Edit jadi "Hello world 2", push → server auto-update
