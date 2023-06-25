# بِسْــــــــــــــــــمِ اللهِ الرَّحْمَنِ الرَّحِيْمِ

# Hackathon Sysadmin Project

Nama saya Rakha Febryza Rasendriya. Asal sekolah SMK Telkom Purwokerto. Disini saya mengambil project tema 1
# Project Wajib Cisco
Untuk script konfigurasi dari langkah-langkah dibawah, sudah saya jadikan satu pada file [script konfigurasi full](https://github.com/RakhaFe21/hackathon-project/blob/master/cisco/script%20konfigurasi%20full)

Langkah-langkah:
1. Setelah semua disusun sedemikian rupa.
Saya membagi projek ini menjadi 2 bagian, yaitu projek atas (router dan core switch) dan projek bawah (core switch, switch dan client nya)
2. Konfigurasi projek bawah yang pertama membuat VLAN pada CoreSw1
3. Konfigurasi VTP Server dan Trunk Port pada CoreSw1
4. Konfigurasi VTP Server dan Trunk Port pada CoreSw2
5. Konfigurasi VTP client dan Trunk port pada semua AccSwitch
6. Menetapkan port ke vlan
7. Konfigurasi STP pada coresw1 dan coresw2
8. konfigurasi etherChannel
9. Konfigurasi HSRP pada coresw1 dan coresw2
10. Setting IP pada server dan PC client
11. Ping antar vlan, server, dan PC
12. konfigurasi bagian projek atas (router) 
13. setelah router sudah di konfigurasi maka selanjutnya konfigurasi routing dinamis ospf area 0 pada coreswitch dan juga router
14. Setelah semua bisa terhubung. Selanjutnya saya menambahkan access list (ACL) standard pada CoreSw untuk membatasi paket. 
Dengan asumsi divisi warehouse hanya boleh fokus ke divisinya saja tidak boleh mengirim paket ke ISP. Maka divisi warehouse saya deny access list nya. 
Akan tetapi divisi warehouse masih bisa mengirim paket kepada rekan kerja sekantornya
15. Alhamdulillah konfigurasi VLAN+STP+VTP+ETHERCHANNEL+HSRP+OSPF+ACL Selesai. 
 

# Project Tema 1
1. Langkah pertama yang saya lakukan adalah saya membuat roadmap alur kerja terlebih dahulu secara oret-oretan pada sebuah buku.
2. Saya menemukan sebuah arsitektur automation kurang lebih seperti pada gambar berikut:
![alt text](https://github.com/RakhaFe21/HackathonProject/blob/master/arsitektur%20otomatisasi.jpeg?raw=true)

# Step by step
1. Sesuai dengan gambar diatas, langkah pertama saya melakukan clonning source code file yang telah di push oleh tim developer yaitu pada app1:       https://github.com/islamyakin/semesta-app1 dan app2 : https://github.com/islamyakin/semesta-app2 
2. Setelah saya cloning kedalam repository local saya, selanjutnya saya membuat dockerfile untuk membuat image dari source code yang telah diberikan menggunakan Visual Studio Code.
3. Selanjutnya yaitu langkah building pada Jenkins. Disini saya menggunakan layanan free tier EC2 dari AWS dengan membuat ubuntu 22.04 sebagai server Jenkins dan server docker
4. Install plugin yang dibutuhkan seperti plugin git,go, publish overssh,discord notifier, dsb.
5. Setting publish over ssh seperti pada gambar berikut:
![alt text](https://github.com/RakhaFe21/HackathonProject/blob/master/Screenshot%20from%202023-06-25%2008-08-12.png?raw=true)
Disini saya membuat dua ssh server untuk masing-masing app
6. Create new job, disini saya membuat 2 job terpisah dengan nama APP1 dan APP2
   # Job APP1:
   - Description : untuk deploy app1
   - Source code management : git
   - Repository URL :
     
           https://github.com/RakhaFe21/semesta-app1.git
   - Branch : */master
   - Build Triggers : Githubhook trigger for GITscm polling (check).
     ![alt text](https://github.com/RakhaFe21/HackathonProject/blob/master/Screenshot%20from%202023-06-25%2008-48-03.png?raw=true)
     Disini saya menambahkan webhook di github dengan ip Jenkins dengan tujuan ketika nanti developers commit perubahan di repository, maka Jenkins akan otomatis membuat build baru.
   - Build environtment : set up Go programming language tools.
     
           Go version : 1.20.5
   - Post Build Actions
     
        - Discord notifier: webhook url
          ![alt text](https://github.com/RakhaFe21/HackathonProject/blob/master/discordchat.png?raw=true)
        
        
          Bertujuan sebagai sumber informasi kepada tim apabila salah satu ada yang memulai build
     	seperti pada contoh gambar dibawah ini :
![alt text](https://github.com/RakhaFe21/HackathonProject/blob/master/Screenshot%20from%202023-06-25%2008-37-43.png?raw=true)

   
       - Send build artifacts over SSH
   
	    Name : docker_host1

            	Transfer set
                 Source file : **/*.go
                 Remove prefix : *kosong
                 Remote directory: /opt/semesta-app1
                 EXEC command:
                 cd /opt/semesta-app1/
                 docker build --tag go1 .
                 docker network create go-network
                 docker run -d -p 3000:3000 --name go1 --network go-network go1
            		
7. Untuk Job app2, saya melakukan copy terhadap app1. Berikut konfigurasi job app2:
   
   # Job APP2:
   	- Description : untuk deploy app2
   	- Source code management : git
   	- Repository URL : https://github.com/RakhaFe21/semesta-app2.git
   	- Branch : */main
   	- Build Triggers : Githubhook trigger for GITscm polling (check)
   	  ![alt text](https://github.com/RakhaFe21/HackathonProject/blob/master/Screenshot%20from%202023-06-25%2014-21-01.png?raw=true)
   	  
   	- Post Build Actions
   
   	  - Discord notifier: webhook url
   
   	![alt text](https://github.com/RakhaFe21/HackathonProject/blob/master/Screenshot%20from%202023-06-25%2008-50-40.png?raw=true)

   Disini saya membuat channel pada server discord yang berbeda dengan app1 agar user dapat dengan mudah mengidentifikasi build

  
   	  
   	- Send build artifacts over SSH

   	  	Name : docker_host2
   	  
	     		Transfer set
	     		Source file : **/*.go
	     		Remove prefix : *kosong
	     		Remote directory: /opt/semesta-app2
	     		EXEC command:
	     		cd /opt/semesta-app2/
	     		docker build --tag go2 .
	     		docker network create go-network
	     		docker run -d -p 3000:3000 --name go2 --network go-network go2

8. Triger build kedua job tersebut dan hasilnya :

    a. APP1

   ![alt text](https://github.com/RakhaFe21/HackathonProject/blob/master/Screenshot%20from%202023-06-25%2008-55-16.png?raw=true)

   b. APP2
   
   ![alt text](https://github.com/RakhaFe21/HackathonProject/blob/master/Screenshot%20from%202023-06-25%2008-55-36.png?raw=true)

9. Screenshoot server docker

![alt text](https://github.com/RakhaFe21/HackathonProject/blob/master/Screenshot%20from%202023-06-25%2008-56-04.png?raw=true)

Container sudah running

10. Pemanggilan melalui browser

    a. APP1

![alt text](https://github.com/RakhaFe21/HackathonProject/blob/master/Screenshot%20from%202023-06-25%2008-58-35.png?raw=true)
    b. APP2

![alt text](https://github.com/RakhaFe21/HackathonProject/blob/master/Screenshot%20from%202023-06-25%2008-59-06.png?raw=true)


# Alhamdulillah, Project Tema 1 berhasil saya kerjakan.
