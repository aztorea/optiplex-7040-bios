00001000  48895c2408             mov qword ptr [rsp + 8], rbx
00001005  57                     push rdi
00001006  4883ec20               sub rsp, 0x20
0000100A  488b4260               mov rax, qword ptr [rdx + 0x60]
0000100E  488bf9                 mov rdi, rcx
00001011  48890db0100000         mov qword ptr [rip + 0x10b0], rcx
00001018  488905b9100000         mov qword ptr [rip + 0x10b9], rax
0000101F  488b4258               mov rax, qword ptr [rdx + 0x58]
00001023  488915a6100000         mov qword ptr [rip + 0x10a6], rdx
0000102A  488bda                 mov rbx, rdx
0000102D  488d0ddc0f0000         lea rcx, [rip + 0xfdc]
00001034  488d15ad100000         lea rdx, [rip + 0x10ad]
0000103B  4889059e100000         mov qword ptr [rip + 0x109e], rax
00001042  e839020000             call 0x1280
00001047  488d15a2100000         lea rdx, [rip + 0x10a2]
0000104E  488d0dab0f0000         lea rcx, [rip + 0xfab]
00001055  e826020000             call 0x1280
0000105A  488bd3                 mov rdx, rbx
0000105D  488bcf                 mov rcx, rdi
00001060  e80b000000             call 0x1070
00001065  488b5c2430             mov rbx, qword ptr [rsp + 0x30]
0000106A  4883c420               add rsp, 0x20
0000106E  5f                     pop rdi
0000106F  c3                     ret 
00001070  4053                   push rbx
00001072  4883ec40               sub rsp, 0x40
00001076  b88d490000             mov eax, 0x498d
0000107B  c744243075b10ab6       mov dword ptr [rsp + 0x30], 0xb60ab175
00001083  c6442438ad             mov byte ptr [rsp + 0x38], 0xad
00001088  6689442434             mov word ptr [rsp + 0x34], ax
0000108D  b89d420000             mov eax, 0x429d
00001092  c6442439ba             mov byte ptr [rsp + 0x39], 0xba
00001097  c644243a0a             mov byte ptr [rsp + 0x3a], 0xa
0000109C  c644243b62             mov byte ptr [rsp + 0x3b], 0x62
000010A1  c644243c2c             mov byte ptr [rsp + 0x3c], 0x2c
000010A6  6689442436             mov word ptr [rsp + 0x36], ax
000010AB  c644243d58             mov byte ptr [rsp + 0x3d], 0x58
000010B0  c644243e16             mov byte ptr [rsp + 0x3e], 0x16
000010B5  c644243fe2             mov byte ptr [rsp + 0x3f], 0xe2
000010BA  b93a010000             mov ecx, 0x13a
000010BF  0f32                   rdmsr 
000010C1  48c1e220               shl rdx, 0x20
000010C5  48b90000000001000000   movabs rcx, 0x100000000
000010CF  480bc2                 or rax, rdx
000010D2  4823c1                 and rax, rcx
000010D5  0f84db000000           je 0x11b6
000010DB  488d542460             lea rdx, [rsp + 0x60]
000010E0  488d0d190f0000         lea rcx, [rip + 0xf19]
000010E7  e894010000             call 0x1280
000010EC  488b542460             mov rdx, qword ptr [rsp + 0x60]
000010F1  66833a01               cmp word ptr [rdx], 1
000010F5  0f85bb000000           jne 0x11b6
000010FB  837a0c20               cmp dword ptr [rdx + 0xc], 0x20
000010FF  0f84b1000000           je 0x11b6
00001105  837a0c12               cmp dword ptr [rdx + 0xc], 0x12
00001109  0f84a7000000           je 0x11b6
0000110F  488b05da0f0000         mov rax, qword ptr [rip + 0xfda]
00001116  488b542438             mov rdx, qword ptr [rsp + 0x38]
0000111B  4c8b442430             mov r8, qword ptr [rsp + 0x30]
00001120  33db                   xor ebx, ebx
00001122  41b9ffff0000           mov r9d, 0xffff
00001128  eb0d                   jmp 0x1137
0000112A  6683f904               cmp cx, 4
0000112E  7413                   je 0x1143
00001130  0fb74802               movzx ecx, word ptr [rax + 2]
00001134  4803c1                 add rax, rcx
00001137  0fb708                 movzx ecx, word ptr [rax]
0000113A  66413bc9               cmp cx, r9w
0000113E  75ea                   jne 0x112a
00001140  488bc3                 mov rax, rbx
00001143  483bc3                 cmp rax, rbx
00001146  7462                   je 0x11aa
00001148  4c3b4008               cmp r8, qword ptr [rax + 8]
0000114C  75e2                   jne 0x1130
0000114E  483b5010               cmp rdx, qword ptr [rax + 0x10]
00001152  75dc                   jne 0x1130
00001154  483bc3                 cmp rax, rbx
00001157  7451                   je 0x11aa
00001159  385818                 cmp byte ptr [rax + 0x18], bl
0000115C  755a                   jne 0x11b8
0000115E  488d442460             lea rax, [rsp + 0x60]
00001163  4533c9                 xor r9d, r9d
00001166  4c8d0557000000         lea r8, [rip + 0x57]
0000116D  4889442420             mov qword ptr [rsp + 0x20], rax
00001172  488b055f0f0000         mov rax, qword ptr [rip + 0xf5f]
00001179  418d5108               lea edx, [r9 + 8]
0000117D  b900020000             mov ecx, 0x200
00001182  ff5050                 call qword ptr [rax + 0x50]
00001185  483bc3                 cmp rax, rbx
00001188  7c2e                   jl 0x11b8
0000118A  488b05470f0000         mov rax, qword ptr [rip + 0xf47]
00001191  488b542460             mov rdx, qword ptr [rsp + 0x60]
00001196  4c8d442468             lea r8, [rsp + 0x68]
0000119B  488d0d7e0e0000         lea rcx, [rip + 0xe7e]
000011A2  ff90a8000000           call qword ptr [rax + 0xa8]
000011A8  eb0e                   jmp 0x11b8
000011AA  48bb0e00000000000080   movabs rbx, 0x800000000000000e
000011B4  eb02                   jmp 0x11b8
000011B6  33db                   xor ebx, ebx
000011B8  488bc3                 mov rax, rbx
000011BB  4883c440               add rsp, 0x40
000011BF  5b                     pop rbx
000011C0  c3                     ret 
000011C1  cc                     int3 
000011C2  cc                     int3 
000011C3  cc                     int3 
000011C4  4053                   push rbx
000011C6  4883ec20               sub rsp, 0x20
000011CA  488b05ff0e0000         mov rax, qword ptr [rip + 0xeff]
000011D1  488bd9                 mov rbx, rcx
000011D4  488b5040               mov rdx, qword ptr [rax + 0x40]
000011D8  488bca                 mov rcx, rdx
000011DB  ff5230                 call qword ptr [rdx + 0x30]
000011DE  4c8b1deb0e0000         mov r11, qword ptr [rip + 0xeeb]
000011E5  488d154c0e0000         lea rdx, [rip + 0xe4c]
000011EC  498b4340               mov rax, qword ptr [r11 + 0x40]
000011F0  488bc8                 mov rcx, rax
000011F3  ff5008                 call qword ptr [rax + 8]
000011F6  4c8b1dd30e0000         mov r11, qword ptr [rip + 0xed3]
000011FD  488d15740e0000         lea rdx, [rip + 0xe74]
00001204  498b4340               mov rax, qword ptr [r11 + 0x40]
00001208  488bc8                 mov rcx, rax
0000120B  ff5008                 call qword ptr [rax + 8]
0000120E  4c8b1dbb0e0000         mov r11, qword ptr [rip + 0xebb]
00001215  488d158c0e0000         lea rdx, [rip + 0xe8c]
0000121C  498b4340               mov rax, qword ptr [r11 + 0x40]
00001220  488bc8                 mov rcx, rax
00001223  ff5008                 call qword ptr [rax + 8]
00001226  488b05a30e0000         mov rax, qword ptr [rip + 0xea3]
0000122D  488d542440             lea rdx, [rsp + 0x40]
00001232  4c8b4030               mov r8, qword ptr [rax + 0x30]
00001236  498bc8                 mov rcx, r8
00001239  41ff5008               call qword ptr [r8 + 8]
0000123D  4885c0                 test rax, rax
00001240  75e4                   jne 0x1226
00001242  8d4802                 lea ecx, [rax + 2]
00001245  488b05940e0000         mov rax, qword ptr [rip + 0xe94]
0000124C  4533c9                 xor r9d, r9d
0000124F  4533c0                 xor r8d, r8d
00001252  33d2                   xor edx, edx
00001254  ff5068                 call qword ptr [rax + 0x68]
00001257  48c744244800000000     mov qword ptr [rsp + 0x48], 0
00001260  488b442448             mov rax, qword ptr [rsp + 0x48]
00001265  4885c0                 test rax, rax
00001268  74f6                   je 0x1260
0000126A  488b05670e0000         mov rax, qword ptr [rip + 0xe67]
00001271  488bcb                 mov rcx, rbx
00001274  ff5070                 call qword ptr [rax + 0x70]
00001277  4883c420               add rsp, 0x20
0000127B  5b                     pop rbx
0000127C  c3                     ret 
0000127D  cc                     int3 
0000127E  cc                     int3 
0000127F  cc                     int3 
00001280  48895c2408             mov qword ptr [rsp + 8], rbx
00001285  488b05440e0000         mov rax, qword ptr [rip + 0xe44]
0000128C  4533c0                 xor r8d, r8d
0000128F  4c8bd1                 mov r10, rcx
00001292  4c8902                 mov qword ptr [rdx], r8
00001295  4c8b5868               mov r11, qword ptr [rax + 0x68]
00001299  4d3bd8                 cmp r11, r8
0000129C  7625                   jbe 0x12c3
0000129E  488b4870               mov rcx, qword ptr [rax + 0x70]
000012A2  498b1a                 mov rbx, qword ptr [r10]
000012A5  4c8bc9                 mov r9, rcx
000012A8  493b19                 cmp rbx, qword ptr [r9]
000012AB  750a                   jne 0x12b7
000012AD  498b4108               mov rax, qword ptr [r9 + 8]
000012B1  49394208               cmp qword ptr [r10 + 8], rax
000012B5  741c                   je 0x12d3
000012B7  49ffc0                 inc r8
000012BA  4983c118               add r9, 0x18
000012BE  4d3bc3                 cmp r8, r11
000012C1  72e5                   jb 0x12a8
000012C3  48b80e00000000000080   movabs rax, 0x800000000000000e
000012CD  488b5c2408             mov rbx, qword ptr [rsp + 8]
000012D2  c3                     ret 
000012D3  4b8d0440               lea rax, [r8 + r8*2]
000012D7  488b4cc110             mov rcx, qword ptr [rcx + rax*8 + 0x10]
000012DC  33c0                   xor eax, eax
000012DE  48890a                 mov qword ptr [rdx], rcx
000012E1  ebea                   jmp 0x12cd
000012E3  cc                     int3 
000012E4  cc                     int3 
000012E5  cc                     int3 
000012E6  cc                     int3 
000012E7  cc                     int3 
000012E8  cc                     int3 
000012E9  cc                     int3 
000012EA  cc                     int3 
000012EB  cc                     int3 
000012EC  cc                     int3 
000012ED  cc                     int3 
000012EE  cc                     int3 
000012EF  cc                     int3 
000012F0  56                     push rsi
000012F1  57                     push rdi
000012F2  488bf2                 mov rsi, rdx
000012F5  488bf9                 mov rdi, rcx
000012F8  4d8d4c30ff             lea r9, [r8 + rsi - 1]
000012FD  483bf7                 cmp rsi, rdi
00001300  488bc7                 mov rax, rdi
00001303  7305                   jae 0x130a
00001305  4c3bcf                 cmp r9, rdi
00001308  7310                   jae 0x131a
0000130A  498bc8                 mov rcx, r8
0000130D  4983e007               and r8, 7
00001311  48c1e903               shr rcx, 3
00001315  f348a5                 rep movsq qword ptr [rdi], qword ptr [rsi]
00001318  eb09                   jmp 0x1323
0000131A  498bf1                 mov rsi, r9
0000131D  498d7c38ff             lea rdi, [r8 + rdi - 1]
00001322  fd                     std 
00001323  498bc8                 mov rcx, r8
00001326  f3a4                   rep movsb byte ptr [rdi], byte ptr [rsi]
00001328  fc                     cld 
00001329  5f                     pop rdi
0000132A  5e                     pop rsi
0000132B  c3                     ret 
0000132C  cc                     int3 
0000132D  cc                     int3 
0000132E  cc                     int3 
0000132F  cc                     int3 
00001330  57                     push rdi
00001331  51                     push rcx
00001332  4833c0                 xor rax, rax
00001335  488bf9                 mov rdi, rcx
00001338  488bca                 mov rcx, rdx
0000133B  48c1e903               shr rcx, 3
0000133F  4883e207               and rdx, 7
00001343  f348ab                 rep stosq qword ptr [rdi], rax
00001346  8bca                   mov ecx, edx
00001348  f3aa                   rep stosb byte ptr [rdi], al
0000134A  58                     pop rax
0000134B  5f                     pop rdi
0000134C  c3                     ret 
0000134D  0000                   add byte ptr [rax], al
0000134F  0000                   add byte ptr [rax], al
00001351  0000                   add byte ptr [rax], al
00001353  0000                   add byte ptr [rax], al
00001355  0000                   add byte ptr [rax], al
00001357  0000                   add byte ptr [rax], al
00001359  0000                   add byte ptr [rax], al
0000135B  0000                   add byte ptr [rax], al
0000135D  0000                   add byte ptr [rax], al
0000135F  0000                   add byte ptr [rax], al
00001361  0000                   add byte ptr [rax], al
00001363  0000                   add byte ptr [rax], al
00001365  0000                   add byte ptr [rax], al
00001367  0000                   add byte ptr [rax], al
00001369  0000                   add byte ptr [rax], al
0000136B  0000                   add byte ptr [rax], al
0000136D  0000                   add byte ptr [rax], al
0000136F  0000                   add byte ptr [rax], al
00001371  0000                   add byte ptr [rax], al
00001373  0000                   add byte ptr [rax], al
00001375  0000                   add byte ptr [rax], al
00001377  0000                   add byte ptr [rax], al
00001379  0000                   add byte ptr [rax], al
0000137B  0000                   add byte ptr [rax], al
0000137D  0000                   add byte ptr [rax], al
0000137F  0000                   add byte ptr [rax], al
00001381  0000                   add byte ptr [rax], al
00001383  0000                   add byte ptr [rax], al
00001385  0000                   add byte ptr [rax], al
00001387  0000                   add byte ptr [rax], al
00001389  0000                   add byte ptr [rax], al
0000138B  0000                   add byte ptr [rax], al
0000138D  0000                   add byte ptr [rax], al
0000138F  0000                   add byte ptr [rax], al
00001391  0000                   add byte ptr [rax], al
00001393  0000                   add byte ptr [rax], al
00001395  0000                   add byte ptr [rax], al
00001397  0000                   add byte ptr [rax], al
00001399  0000                   add byte ptr [rax], al
0000139B  0000                   add byte ptr [rax], al
0000139D  0000                   add byte ptr [rax], al
0000139F  0000                   add byte ptr [rax], al
000013A1  0000                   add byte ptr [rax], al
000013A3  0000                   add byte ptr [rax], al
000013A5  0000                   add byte ptr [rax], al
000013A7  0000                   add byte ptr [rax], al
000013A9  0000                   add byte ptr [rax], al
000013AB  0000                   add byte ptr [rax], al
000013AD  0000                   add byte ptr [rax], al
000013AF  0000                   add byte ptr [rax], al
000013B1  0000                   add byte ptr [rax], al
000013B3  0000                   add byte ptr [rax], al
000013B5  0000                   add byte ptr [rax], al
000013B7  0000                   add byte ptr [rax], al
000013B9  0000                   add byte ptr [rax], al
000013BB  0000                   add byte ptr [rax], al
000013BD  0000                   add byte ptr [rax], al
000013BF  0000                   add byte ptr [rax], al
000013C1  0000                   add byte ptr [rax], al
000013C3  0000                   add byte ptr [rax], al
000013C5  0000                   add byte ptr [rax], al
000013C7  0000                   add byte ptr [rax], al
000013C9  0000                   add byte ptr [rax], al
000013CB  0000                   add byte ptr [rax], al
000013CD  0000                   add byte ptr [rax], al
000013CF  0000                   add byte ptr [rax], al
000013D1  0000                   add byte ptr [rax], al
000013D3  0000                   add byte ptr [rax], al
000013D5  0000                   add byte ptr [rax], al
000013D7  0000                   add byte ptr [rax], al
000013D9  0000                   add byte ptr [rax], al
000013DB  0000                   add byte ptr [rax], al
000013DD  0000                   add byte ptr [rax], al
000013DF  0000                   add byte ptr [rax], al
000013E1  0000                   add byte ptr [rax], al
000013E3  0000                   add byte ptr [rax], al
000013E5  0000                   add byte ptr [rax], al
000013E7  0000                   add byte ptr [rax], al
000013E9  0000                   add byte ptr [rax], al
000013EB  0000                   add byte ptr [rax], al
000013ED  0000                   add byte ptr [rax], al
000013EF  0000                   add byte ptr [rax], al
000013F1  0000                   add byte ptr [rax], al
000013F3  0000                   add byte ptr [rax], al
000013F5  0000                   add byte ptr [rax], al
000013F7  0000                   add byte ptr [rax], al
000013F9  0000                   add byte ptr [rax], al
000013FB  0000                   add byte ptr [rax], al
000013FD  0000                   add byte ptr [rax], al
000013FF  0000                   add byte ptr [rax], al
00001401  0000                   add byte ptr [rax], al
00001403  0000                   add byte ptr [rax], al
00001405  0000                   add byte ptr [rax], al
00001407  0000                   add byte ptr [rax], al
00001409  0000                   add byte ptr [rax], al
0000140B  0000                   add byte ptr [rax], al
0000140D  0000                   add byte ptr [rax], al
0000140F  0000                   add byte ptr [rax], al
00001411  0000                   add byte ptr [rax], al
00001413  0000                   add byte ptr [rax], al
00001415  0000                   add byte ptr [rax], al
00001417  0000                   add byte ptr [rax], al
00001419  0000                   add byte ptr [rax], al
0000141B  0000                   add byte ptr [rax], al
0000141D  0000                   add byte ptr [rax], al
0000141F  0000                   add byte ptr [rax], al
00001421  0000                   add byte ptr [rax], al
00001423  0000                   add byte ptr [rax], al
00001425  0000                   add byte ptr [rax], al
00001427  0000                   add byte ptr [rax], al
00001429  0000                   add byte ptr [rax], al
0000142B  0000                   add byte ptr [rax], al
0000142D  0000                   add byte ptr [rax], al
0000142F  0000                   add byte ptr [rax], al
00001431  0000                   add byte ptr [rax], al
00001433  0000                   add byte ptr [rax], al
00001435  0000                   add byte ptr [rax], al
00001437  0000                   add byte ptr [rax], al
00001439  0000                   add byte ptr [rax], al
0000143B  0000                   add byte ptr [rax], al
0000143D  0000                   add byte ptr [rax], al
0000143F  0000                   add byte ptr [rax], al
00001441  0000                   add byte ptr [rax], al
00001443  0000                   add byte ptr [rax], al
00001445  0000                   add byte ptr [rax], al
00001447  0000                   add byte ptr [rax], al
00001449  0000                   add byte ptr [rax], al
0000144B  0000                   add byte ptr [rax], al
0000144D  0000                   add byte ptr [rax], al
0000144F  0000                   add byte ptr [rax], al
00001451  0000                   add byte ptr [rax], al
00001453  0000                   add byte ptr [rax], al
00001455  0000                   add byte ptr [rax], al
00001457  0000                   add byte ptr [rax], al
00001459  0000                   add byte ptr [rax], al
0000145B  0000                   add byte ptr [rax], al
0000145D  0000                   add byte ptr [rax], al
0000145F  0000                   add byte ptr [rax], al
00001461  0000                   add byte ptr [rax], al
00001463  0000                   add byte ptr [rax], al
00001465  0000                   add byte ptr [rax], al
00001467  0000                   add byte ptr [rax], al
00001469  0000                   add byte ptr [rax], al
0000146B  0000                   add byte ptr [rax], al
0000146D  0000                   add byte ptr [rax], al
0000146F  0000                   add byte ptr [rax], al
00001471  0000                   add byte ptr [rax], al
00001473  0000                   add byte ptr [rax], al
00001475  0000                   add byte ptr [rax], al
00001477  0000                   add byte ptr [rax], al
00001479  0000                   add byte ptr [rax], al
0000147B  0000                   add byte ptr [rax], al
0000147D  0000                   add byte ptr [rax], al
0000147F  0000                   add byte ptr [rax], al
00001481  0000                   add byte ptr [rax], al
00001483  0000                   add byte ptr [rax], al
00001485  0000                   add byte ptr [rax], al
00001487  0000                   add byte ptr [rax], al
00001489  0000                   add byte ptr [rax], al
0000148B  0000                   add byte ptr [rax], al
0000148D  0000                   add byte ptr [rax], al
0000148F  0000                   add byte ptr [rax], al
00001491  0000                   add byte ptr [rax], al
00001493  0000                   add byte ptr [rax], al
00001495  0000                   add byte ptr [rax], al
00001497  0000                   add byte ptr [rax], al
00001499  0000                   add byte ptr [rax], al
0000149B  0000                   add byte ptr [rax], al
0000149D  0000                   add byte ptr [rax], al
0000149F  0000                   add byte ptr [rax], al
000014A1  0000                   add byte ptr [rax], al
000014A3  0000                   add byte ptr [rax], al
000014A5  0000                   add byte ptr [rax], al
000014A7  0000                   add byte ptr [rax], al
000014A9  0000                   add byte ptr [rax], al
000014AB  0000                   add byte ptr [rax], al
000014AD  0000                   add byte ptr [rax], al
000014AF  0000                   add byte ptr [rax], al
000014B1  0000                   add byte ptr [rax], al
000014B3  0000                   add byte ptr [rax], al
000014B5  0000                   add byte ptr [rax], al
000014B7  0000                   add byte ptr [rax], al
000014B9  0000                   add byte ptr [rax], al
000014BB  0000                   add byte ptr [rax], al
000014BD  0000                   add byte ptr [rax], al
000014BF  0000                   add byte ptr [rax], al
000014C1  0000                   add byte ptr [rax], al
000014C3  0000                   add byte ptr [rax], al
000014C5  0000                   add byte ptr [rax], al
000014C7  0000                   add byte ptr [rax], al
000014C9  0000                   add byte ptr [rax], al
000014CB  0000                   add byte ptr [rax], al
000014CD  0000                   add byte ptr [rax], al
000014CF  0000                   add byte ptr [rax], al
000014D1  0000                   add byte ptr [rax], al
000014D3  0000                   add byte ptr [rax], al
000014D5  0000                   add byte ptr [rax], al
000014D7  0000                   add byte ptr [rax], al
000014D9  0000                   add byte ptr [rax], al
000014DB  0000                   add byte ptr [rax], al
000014DD  0000                   add byte ptr [rax], al
000014DF  0000                   add byte ptr [rax], al
000014E1  0000                   add byte ptr [rax], al
000014E3  0000                   add byte ptr [rax], al
000014E5  0000                   add byte ptr [rax], al
000014E7  0000                   add byte ptr [rax], al
000014E9  0000                   add byte ptr [rax], al
000014EB  0000                   add byte ptr [rax], al
000014ED  0000                   add byte ptr [rax], al
000014EF  0000                   add byte ptr [rax], al
000014F1  0000                   add byte ptr [rax], al
000014F3  0000                   add byte ptr [rax], al
000014F5  0000                   add byte ptr [rax], al
000014F7  0000                   add byte ptr [rax], al
000014F9  0000                   add byte ptr [rax], al
000014FB  0000                   add byte ptr [rax], al
000014FD  0000                   add byte ptr [rax], al
000014FF  0000                   add byte ptr [rax], al
00001501  0000                   add byte ptr [rax], al
00001503  0000                   add byte ptr [rax], al
00001505  0000                   add byte ptr [rax], al
00001507  0000                   add byte ptr [rax], al
00001509  0000                   add byte ptr [rax], al
0000150B  0000                   add byte ptr [rax], al
0000150D  0000                   add byte ptr [rax], al
0000150F  0000                   add byte ptr [rax], al
00001511  0000                   add byte ptr [rax], al
00001513  0000                   add byte ptr [rax], al
00001515  0000                   add byte ptr [rax], al
00001517  0000                   add byte ptr [rax], al
00001519  0000                   add byte ptr [rax], al
0000151B  0000                   add byte ptr [rax], al
0000151D  0000                   add byte ptr [rax], al
0000151F  0000                   add byte ptr [rax], al
00001521  0000                   add byte ptr [rax], al
00001523  0000                   add byte ptr [rax], al
00001525  0000                   add byte ptr [rax], al
00001527  0000                   add byte ptr [rax], al
00001529  0000                   add byte ptr [rax], al
0000152B  0000                   add byte ptr [rax], al
0000152D  0000                   add byte ptr [rax], al
0000152F  0000                   add byte ptr [rax], al
00001531  0000                   add byte ptr [rax], al
00001533  0000                   add byte ptr [rax], al
00001535  0000                   add byte ptr [rax], al
00001537  0000                   add byte ptr [rax], al
00001539  0000                   add byte ptr [rax], al
0000153B  0000                   add byte ptr [rax], al
0000153D  0000                   add byte ptr [rax], al
0000153F  0000                   add byte ptr [rax], al
00001541  0000                   add byte ptr [rax], al
00001543  0000                   add byte ptr [rax], al
00001545  0000                   add byte ptr [rax], al
00001547  0000                   add byte ptr [rax], al
00001549  0000                   add byte ptr [rax], al
0000154B  0000                   add byte ptr [rax], al
0000154D  0000                   add byte ptr [rax], al
0000154F  0000                   add byte ptr [rax], al
00001551  0000                   add byte ptr [rax], al
00001553  0000                   add byte ptr [rax], al
00001555  0000                   add byte ptr [rax], al
00001557  0000                   add byte ptr [rax], al
00001559  0000                   add byte ptr [rax], al
0000155B  0000                   add byte ptr [rax], al
0000155D  0000                   add byte ptr [rax], al
0000155F  0000                   add byte ptr [rax], al
00001561  0000                   add byte ptr [rax], al
00001563  0000                   add byte ptr [rax], al
00001565  0000                   add byte ptr [rax], al
00001567  0000                   add byte ptr [rax], al
00001569  0000                   add byte ptr [rax], al
0000156B  0000                   add byte ptr [rax], al
0000156D  0000                   add byte ptr [rax], al
0000156F  0000                   add byte ptr [rax], al
00001571  0000                   add byte ptr [rax], al
00001573  0000                   add byte ptr [rax], al
00001575  0000                   add byte ptr [rax], al
00001577  0000                   add byte ptr [rax], al
00001579  0000                   add byte ptr [rax], al
0000157B  0000                   add byte ptr [rax], al
0000157D  0000                   add byte ptr [rax], al
0000157F  0000                   add byte ptr [rax], al
00001581  0000                   add byte ptr [rax], al
00001583  0000                   add byte ptr [rax], al
00001585  0000                   add byte ptr [rax], al
00001587  0000                   add byte ptr [rax], al
00001589  0000                   add byte ptr [rax], al
0000158B  0000                   add byte ptr [rax], al
0000158D  0000                   add byte ptr [rax], al
0000158F  0000                   add byte ptr [rax], al
00001591  0000                   add byte ptr [rax], al
00001593  0000                   add byte ptr [rax], al
00001595  0000                   add byte ptr [rax], al
00001597  0000                   add byte ptr [rax], al
00001599  0000                   add byte ptr [rax], al
0000159B  0000                   add byte ptr [rax], al
0000159D  0000                   add byte ptr [rax], al
0000159F  0000                   add byte ptr [rax], al
000015A1  0000                   add byte ptr [rax], al
000015A3  0000                   add byte ptr [rax], al
000015A5  0000                   add byte ptr [rax], al
000015A7  0000                   add byte ptr [rax], al
000015A9  0000                   add byte ptr [rax], al
000015AB  0000                   add byte ptr [rax], al
000015AD  0000                   add byte ptr [rax], al
000015AF  0000                   add byte ptr [rax], al
000015B1  0000                   add byte ptr [rax], al
000015B3  0000                   add byte ptr [rax], al
000015B5  0000                   add byte ptr [rax], al
000015B7  0000                   add byte ptr [rax], al
000015B9  0000                   add byte ptr [rax], al
000015BB  0000                   add byte ptr [rax], al
000015BD  0000                   add byte ptr [rax], al
000015BF  0000                   add byte ptr [rax], al
000015C1  0000                   add byte ptr [rax], al
000015C3  0000                   add byte ptr [rax], al
000015C5  0000                   add byte ptr [rax], al
000015C7  0000                   add byte ptr [rax], al
000015C9  0000                   add byte ptr [rax], al
000015CB  0000                   add byte ptr [rax], al
000015CD  0000                   add byte ptr [rax], al
000015CF  0000                   add byte ptr [rax], al
000015D1  0000                   add byte ptr [rax], al
000015D3  0000                   add byte ptr [rax], al
000015D5  0000                   add byte ptr [rax], al
000015D7  0000                   add byte ptr [rax], al
000015D9  0000                   add byte ptr [rax], al
000015DB  0000                   add byte ptr [rax], al
000015DD  0000                   add byte ptr [rax], al
000015DF  0000                   add byte ptr [rax], al
000015E1  0000                   add byte ptr [rax], al
000015E3  0000                   add byte ptr [rax], al
000015E5  0000                   add byte ptr [rax], al
000015E7  0000                   add byte ptr [rax], al
000015E9  0000                   add byte ptr [rax], al
000015EB  0000                   add byte ptr [rax], al
000015ED  0000                   add byte ptr [rax], al
000015EF  0000                   add byte ptr [rax], al
000015F1  0000                   add byte ptr [rax], al
000015F3  0000                   add byte ptr [rax], al
000015F5  0000                   add byte ptr [rax], al
000015F7  0000                   add byte ptr [rax], al
000015F9  0000                   add byte ptr [rax], al
000015FB  0000                   add byte ptr [rax], al
000015FD  0000                   add byte ptr [rax], al
000015FF  0000                   add byte ptr [rax], al
00001601  0000                   add byte ptr [rax], al
00001603  0000                   add byte ptr [rax], al
00001605  0000                   add byte ptr [rax], al
00001607  0000                   add byte ptr [rax], al
00001609  0000                   add byte ptr [rax], al
0000160B  0000                   add byte ptr [rax], al
0000160D  0000                   add byte ptr [rax], al
0000160F  0000                   add byte ptr [rax], al
00001611  0000                   add byte ptr [rax], al
00001613  0000                   add byte ptr [rax], al
00001615  0000                   add byte ptr [rax], al
00001617  0000                   add byte ptr [rax], al
00001619  0000                   add byte ptr [rax], al
0000161B  0000                   add byte ptr [rax], al
0000161D  0000                   add byte ptr [rax], al
0000161F  0000                   add byte ptr [rax], al
00001621  0000                   add byte ptr [rax], al
00001623  0000                   add byte ptr [rax], al
00001625  0000                   add byte ptr [rax], al
00001627  0000                   add byte ptr [rax], al
00001629  0000                   add byte ptr [rax], al
0000162B  0000                   add byte ptr [rax], al
0000162D  0000                   add byte ptr [rax], al
0000162F  0000                   add byte ptr [rax], al
00001631  0000                   add byte ptr [rax], al
00001633  0000                   add byte ptr [rax], al
00001635  0000                   add byte ptr [rax], al
00001637  0000                   add byte ptr [rax], al
00001639  0000                   add byte ptr [rax], al
0000163B  0000                   add byte ptr [rax], al
0000163D  0000                   add byte ptr [rax], al
0000163F  0000                   add byte ptr [rax], al
00001641  0000                   add byte ptr [rax], al
00001643  0000                   add byte ptr [rax], al
00001645  0000                   add byte ptr [rax], al
00001647  0000                   add byte ptr [rax], al
00001649  0000                   add byte ptr [rax], al
0000164B  0000                   add byte ptr [rax], al
0000164D  0000                   add byte ptr [rax], al
0000164F  0000                   add byte ptr [rax], al
00001651  0000                   add byte ptr [rax], al
00001653  0000                   add byte ptr [rax], al
00001655  0000                   add byte ptr [rax], al
00001657  0000                   add byte ptr [rax], al
00001659  0000                   add byte ptr [rax], al
0000165B  0000                   add byte ptr [rax], al
0000165D  0000                   add byte ptr [rax], al
0000165F  0000                   add byte ptr [rax], al
00001661  0000                   add byte ptr [rax], al
00001663  0000                   add byte ptr [rax], al
00001665  0000                   add byte ptr [rax], al
00001667  0000                   add byte ptr [rax], al
00001669  0000                   add byte ptr [rax], al
0000166B  0000                   add byte ptr [rax], al
0000166D  0000                   add byte ptr [rax], al
0000166F  0000                   add byte ptr [rax], al
00001671  0000                   add byte ptr [rax], al
00001673  0000                   add byte ptr [rax], al
00001675  0000                   add byte ptr [rax], al
00001677  0000                   add byte ptr [rax], al
00001679  0000                   add byte ptr [rax], al
0000167B  0000                   add byte ptr [rax], al
0000167D  0000                   add byte ptr [rax], al
0000167F  0000                   add byte ptr [rax], al
00001681  0000                   add byte ptr [rax], al
00001683  0000                   add byte ptr [rax], al
00001685  0000                   add byte ptr [rax], al
00001687  0000                   add byte ptr [rax], al
00001689  0000                   add byte ptr [rax], al
0000168B  0000                   add byte ptr [rax], al
0000168D  0000                   add byte ptr [rax], al
0000168F  0000                   add byte ptr [rax], al
00001691  0000                   add byte ptr [rax], al
00001693  0000                   add byte ptr [rax], al
00001695  0000                   add byte ptr [rax], al
00001697  0000                   add byte ptr [rax], al
00001699  0000                   add byte ptr [rax], al
0000169B  0000                   add byte ptr [rax], al
0000169D  0000                   add byte ptr [rax], al
0000169F  0000                   add byte ptr [rax], al
000016A1  0000                   add byte ptr [rax], al
000016A3  0000                   add byte ptr [rax], al
000016A5  0000                   add byte ptr [rax], al
000016A7  0000                   add byte ptr [rax], al
000016A9  0000                   add byte ptr [rax], al
000016AB  0000                   add byte ptr [rax], al
000016AD  0000                   add byte ptr [rax], al
000016AF  0000                   add byte ptr [rax], al
000016B1  0000                   add byte ptr [rax], al
000016B3  0000                   add byte ptr [rax], al
000016B5  0000                   add byte ptr [rax], al
000016B7  0000                   add byte ptr [rax], al
000016B9  0000                   add byte ptr [rax], al
000016BB  0000                   add byte ptr [rax], al
000016BD  0000                   add byte ptr [rax], al
000016BF  0000                   add byte ptr [rax], al
000016C1  0000                   add byte ptr [rax], al
000016C3  0000                   add byte ptr [rax], al
000016C5  0000                   add byte ptr [rax], al
000016C7  0000                   add byte ptr [rax], al
000016C9  0000                   add byte ptr [rax], al
000016CB  0000                   add byte ptr [rax], al
000016CD  0000                   add byte ptr [rax], al
000016CF  0000                   add byte ptr [rax], al
000016D1  0000                   add byte ptr [rax], al
000016D3  0000                   add byte ptr [rax], al
000016D5  0000                   add byte ptr [rax], al
000016D7  0000                   add byte ptr [rax], al
000016D9  0000                   add byte ptr [rax], al
000016DB  0000                   add byte ptr [rax], al
000016DD  0000                   add byte ptr [rax], al
000016DF  0000                   add byte ptr [rax], al
000016E1  0000                   add byte ptr [rax], al
000016E3  0000                   add byte ptr [rax], al
000016E5  0000                   add byte ptr [rax], al
000016E7  0000                   add byte ptr [rax], al
000016E9  0000                   add byte ptr [rax], al
000016EB  0000                   add byte ptr [rax], al
000016ED  0000                   add byte ptr [rax], al
000016EF  0000                   add byte ptr [rax], al
000016F1  0000                   add byte ptr [rax], al
000016F3  0000                   add byte ptr [rax], al
000016F5  0000                   add byte ptr [rax], al
000016F7  0000                   add byte ptr [rax], al
000016F9  0000                   add byte ptr [rax], al
000016FB  0000                   add byte ptr [rax], al
000016FD  0000                   add byte ptr [rax], al
000016FF  0000                   add byte ptr [rax], al
00001701  0000                   add byte ptr [rax], al
00001703  0000                   add byte ptr [rax], al
00001705  0000                   add byte ptr [rax], al
00001707  0000                   add byte ptr [rax], al
00001709  0000                   add byte ptr [rax], al
0000170B  0000                   add byte ptr [rax], al
0000170D  0000                   add byte ptr [rax], al
0000170F  0000                   add byte ptr [rax], al
00001711  0000                   add byte ptr [rax], al
00001713  0000                   add byte ptr [rax], al
00001715  0000                   add byte ptr [rax], al
00001717  0000                   add byte ptr [rax], al
00001719  0000                   add byte ptr [rax], al
0000171B  0000                   add byte ptr [rax], al
0000171D  0000                   add byte ptr [rax], al
0000171F  0000                   add byte ptr [rax], al
00001721  0000                   add byte ptr [rax], al
00001723  0000                   add byte ptr [rax], al
00001725  0000                   add byte ptr [rax], al
00001727  0000                   add byte ptr [rax], al
00001729  0000                   add byte ptr [rax], al
0000172B  0000                   add byte ptr [rax], al
0000172D  0000                   add byte ptr [rax], al
0000172F  0000                   add byte ptr [rax], al
00001731  0000                   add byte ptr [rax], al
00001733  0000                   add byte ptr [rax], al
00001735  0000                   add byte ptr [rax], al
00001737  0000                   add byte ptr [rax], al
00001739  0000                   add byte ptr [rax], al
0000173B  0000                   add byte ptr [rax], al
0000173D  0000                   add byte ptr [rax], al
0000173F  0000                   add byte ptr [rax], al
00001741  0000                   add byte ptr [rax], al
00001743  0000                   add byte ptr [rax], al
00001745  0000                   add byte ptr [rax], al
00001747  0000                   add byte ptr [rax], al
00001749  0000                   add byte ptr [rax], al
0000174B  0000                   add byte ptr [rax], al
0000174D  0000                   add byte ptr [rax], al
0000174F  0000                   add byte ptr [rax], al
00001751  0000                   add byte ptr [rax], al
00001753  0000                   add byte ptr [rax], al
00001755  0000                   add byte ptr [rax], al
00001757  0000                   add byte ptr [rax], al
00001759  0000                   add byte ptr [rax], al
0000175B  0000                   add byte ptr [rax], al
0000175D  0000                   add byte ptr [rax], al
0000175F  0000                   add byte ptr [rax], al
00001761  0000                   add byte ptr [rax], al
00001763  0000                   add byte ptr [rax], al
00001765  0000                   add byte ptr [rax], al
00001767  0000                   add byte ptr [rax], al
00001769  0000                   add byte ptr [rax], al
0000176B  0000                   add byte ptr [rax], al
0000176D  0000                   add byte ptr [rax], al
0000176F  0000                   add byte ptr [rax], al
00001771  0000                   add byte ptr [rax], al
00001773  0000                   add byte ptr [rax], al
00001775  0000                   add byte ptr [rax], al
00001777  0000                   add byte ptr [rax], al
00001779  0000                   add byte ptr [rax], al
0000177B  0000                   add byte ptr [rax], al
0000177D  0000                   add byte ptr [rax], al
0000177F  0000                   add byte ptr [rax], al
00001781  0000                   add byte ptr [rax], al
00001783  0000                   add byte ptr [rax], al
00001785  0000                   add byte ptr [rax], al
00001787  0000                   add byte ptr [rax], al
00001789  0000                   add byte ptr [rax], al
0000178B  0000                   add byte ptr [rax], al
0000178D  0000                   add byte ptr [rax], al
0000178F  0000                   add byte ptr [rax], al
00001791  0000                   add byte ptr [rax], al
00001793  0000                   add byte ptr [rax], al
00001795  0000                   add byte ptr [rax], al
00001797  0000                   add byte ptr [rax], al
00001799  0000                   add byte ptr [rax], al
0000179B  0000                   add byte ptr [rax], al
0000179D  0000                   add byte ptr [rax], al
0000179F  0000                   add byte ptr [rax], al
000017A1  0000                   add byte ptr [rax], al
000017A3  0000                   add byte ptr [rax], al
000017A5  0000                   add byte ptr [rax], al
000017A7  0000                   add byte ptr [rax], al
000017A9  0000                   add byte ptr [rax], al
000017AB  0000                   add byte ptr [rax], al
000017AD  0000                   add byte ptr [rax], al
000017AF  0000                   add byte ptr [rax], al
000017B1  0000                   add byte ptr [rax], al
000017B3  0000                   add byte ptr [rax], al
000017B5  0000                   add byte ptr [rax], al
000017B7  0000                   add byte ptr [rax], al
000017B9  0000                   add byte ptr [rax], al
000017BB  0000                   add byte ptr [rax], al
000017BD  0000                   add byte ptr [rax], al
000017BF  0000                   add byte ptr [rax], al
000017C1  0000                   add byte ptr [rax], al
000017C3  0000                   add byte ptr [rax], al
000017C5  0000                   add byte ptr [rax], al
000017C7  0000                   add byte ptr [rax], al
000017C9  0000                   add byte ptr [rax], al
000017CB  0000                   add byte ptr [rax], al
000017CD  0000                   add byte ptr [rax], al
000017CF  0000                   add byte ptr [rax], al
000017D1  0000                   add byte ptr [rax], al
000017D3  0000                   add byte ptr [rax], al
000017D5  0000                   add byte ptr [rax], al
000017D7  0000                   add byte ptr [rax], al
000017D9  0000                   add byte ptr [rax], al
000017DB  0000                   add byte ptr [rax], al
000017DD  0000                   add byte ptr [rax], al
000017DF  0000                   add byte ptr [rax], al
000017E1  0000                   add byte ptr [rax], al
000017E3  0000                   add byte ptr [rax], al
000017E5  0000                   add byte ptr [rax], al
000017E7  0000                   add byte ptr [rax], al
000017E9  0000                   add byte ptr [rax], al
000017EB  0000                   add byte ptr [rax], al
000017ED  0000                   add byte ptr [rax], al
000017EF  0000                   add byte ptr [rax], al
000017F1  0000                   add byte ptr [rax], al
000017F3  0000                   add byte ptr [rax], al
000017F5  0000                   add byte ptr [rax], al
000017F7  0000                   add byte ptr [rax], al
000017F9  0000                   add byte ptr [rax], al
000017FB  0000                   add byte ptr [rax], al
000017FD  0000                   add byte ptr [rax], al
000017FF  0000                   add byte ptr [rax], al
00001801  0000                   add byte ptr [rax], al
00001803  0000                   add byte ptr [rax], al
00001805  0000                   add byte ptr [rax], al
00001807  0000                   add byte ptr [rax], al
00001809  0000                   add byte ptr [rax], al
0000180B  0000                   add byte ptr [rax], al
0000180D  0000                   add byte ptr [rax], al
0000180F  0000                   add byte ptr [rax], al
00001811  0000                   add byte ptr [rax], al
00001813  0000                   add byte ptr [rax], al
00001815  0000                   add byte ptr [rax], al
00001817  0000                   add byte ptr [rax], al
00001819  0000                   add byte ptr [rax], al
0000181B  0000                   add byte ptr [rax], al
0000181D  0000                   add byte ptr [rax], al
0000181F  0000                   add byte ptr [rax], al
00001821  0000                   add byte ptr [rax], al
00001823  0000                   add byte ptr [rax], al
00001825  0000                   add byte ptr [rax], al
00001827  0000                   add byte ptr [rax], al
00001829  0000                   add byte ptr [rax], al
0000182B  0000                   add byte ptr [rax], al
0000182D  0000                   add byte ptr [rax], al
0000182F  0000                   add byte ptr [rax], al
00001831  0000                   add byte ptr [rax], al
00001833  0000                   add byte ptr [rax], al
00001835  0000                   add byte ptr [rax], al
00001837  0000                   add byte ptr [rax], al
00001839  0000                   add byte ptr [rax], al
0000183B  0000                   add byte ptr [rax], al
0000183D  0000                   add byte ptr [rax], al
0000183F  0000                   add byte ptr [rax], al
00001841  0000                   add byte ptr [rax], al
00001843  0000                   add byte ptr [rax], al
00001845  0000                   add byte ptr [rax], al
00001847  0000                   add byte ptr [rax], al
00001849  0000                   add byte ptr [rax], al
0000184B  0000                   add byte ptr [rax], al
0000184D  0000                   add byte ptr [rax], al
0000184F  0000                   add byte ptr [rax], al
00001851  0000                   add byte ptr [rax], al
00001853  0000                   add byte ptr [rax], al
00001855  0000                   add byte ptr [rax], al
00001857  0000                   add byte ptr [rax], al
00001859  0000                   add byte ptr [rax], al
0000185B  0000                   add byte ptr [rax], al
0000185D  0000                   add byte ptr [rax], al
0000185F  0000                   add byte ptr [rax], al
00001861  0000                   add byte ptr [rax], al
00001863  0000                   add byte ptr [rax], al
00001865  0000                   add byte ptr [rax], al
00001867  0000                   add byte ptr [rax], al
00001869  0000                   add byte ptr [rax], al
0000186B  0000                   add byte ptr [rax], al
0000186D  0000                   add byte ptr [rax], al
0000186F  0000                   add byte ptr [rax], al
00001871  0000                   add byte ptr [rax], al
00001873  0000                   add byte ptr [rax], al
00001875  0000                   add byte ptr [rax], al
00001877  0000                   add byte ptr [rax], al
00001879  0000                   add byte ptr [rax], al
0000187B  0000                   add byte ptr [rax], al
0000187D  0000                   add byte ptr [rax], al
0000187F  0000                   add byte ptr [rax], al
00001881  0000                   add byte ptr [rax], al
00001883  0000                   add byte ptr [rax], al
00001885  0000                   add byte ptr [rax], al
00001887  0000                   add byte ptr [rax], al
00001889  0000                   add byte ptr [rax], al
0000188B  0000                   add byte ptr [rax], al
0000188D  0000                   add byte ptr [rax], al
0000188F  0000                   add byte ptr [rax], al
00001891  0000                   add byte ptr [rax], al
00001893  0000                   add byte ptr [rax], al
00001895  0000                   add byte ptr [rax], al
00001897  0000                   add byte ptr [rax], al
00001899  0000                   add byte ptr [rax], al
0000189B  0000                   add byte ptr [rax], al
0000189D  0000                   add byte ptr [rax], al
0000189F  0000                   add byte ptr [rax], al
000018A1  0000                   add byte ptr [rax], al
000018A3  0000                   add byte ptr [rax], al
000018A5  0000                   add byte ptr [rax], al
000018A7  0000                   add byte ptr [rax], al
000018A9  0000                   add byte ptr [rax], al
000018AB  0000                   add byte ptr [rax], al
000018AD  0000                   add byte ptr [rax], al
000018AF  0000                   add byte ptr [rax], al
000018B1  0000                   add byte ptr [rax], al
000018B3  0000                   add byte ptr [rax], al
000018B5  0000                   add byte ptr [rax], al
000018B7  0000                   add byte ptr [rax], al
000018B9  0000                   add byte ptr [rax], al
000018BB  0000                   add byte ptr [rax], al
000018BD  0000                   add byte ptr [rax], al
000018BF  0000                   add byte ptr [rax], al
000018C1  0000                   add byte ptr [rax], al
000018C3  0000                   add byte ptr [rax], al
000018C5  0000                   add byte ptr [rax], al
000018C7  0000                   add byte ptr [rax], al
000018C9  0000                   add byte ptr [rax], al
000018CB  0000                   add byte ptr [rax], al
000018CD  0000                   add byte ptr [rax], al
000018CF  0000                   add byte ptr [rax], al
000018D1  0000                   add byte ptr [rax], al
000018D3  0000                   add byte ptr [rax], al
000018D5  0000                   add byte ptr [rax], al
000018D7  0000                   add byte ptr [rax], al
000018D9  0000                   add byte ptr [rax], al
000018DB  0000                   add byte ptr [rax], al
000018DD  0000                   add byte ptr [rax], al
000018DF  0000                   add byte ptr [rax], al
000018E1  0000                   add byte ptr [rax], al
000018E3  0000                   add byte ptr [rax], al
000018E5  0000                   add byte ptr [rax], al
000018E7  0000                   add byte ptr [rax], al
000018E9  0000                   add byte ptr [rax], al
000018EB  0000                   add byte ptr [rax], al
000018ED  0000                   add byte ptr [rax], al
000018EF  0000                   add byte ptr [rax], al
000018F1  0000                   add byte ptr [rax], al
000018F3  0000                   add byte ptr [rax], al
000018F5  0000                   add byte ptr [rax], al
000018F7  0000                   add byte ptr [rax], al
000018F9  0000                   add byte ptr [rax], al
000018FB  0000                   add byte ptr [rax], al
000018FD  0000                   add byte ptr [rax], al
000018FF  0000                   add byte ptr [rax], al
00001901  0000                   add byte ptr [rax], al
00001903  0000                   add byte ptr [rax], al
00001905  0000                   add byte ptr [rax], al
00001907  0000                   add byte ptr [rax], al
00001909  0000                   add byte ptr [rax], al
0000190B  0000                   add byte ptr [rax], al
0000190D  0000                   add byte ptr [rax], al
0000190F  0000                   add byte ptr [rax], al
00001911  0000                   add byte ptr [rax], al
00001913  0000                   add byte ptr [rax], al
00001915  0000                   add byte ptr [rax], al
00001917  0000                   add byte ptr [rax], al
00001919  0000                   add byte ptr [rax], al
0000191B  0000                   add byte ptr [rax], al
0000191D  0000                   add byte ptr [rax], al
0000191F  0000                   add byte ptr [rax], al
00001921  0000                   add byte ptr [rax], al
00001923  0000                   add byte ptr [rax], al
00001925  0000                   add byte ptr [rax], al
00001927  0000                   add byte ptr [rax], al
00001929  0000                   add byte ptr [rax], al
0000192B  0000                   add byte ptr [rax], al
0000192D  0000                   add byte ptr [rax], al
0000192F  0000                   add byte ptr [rax], al
00001931  0000                   add byte ptr [rax], al
00001933  0000                   add byte ptr [rax], al
00001935  0000                   add byte ptr [rax], al
00001937  0000                   add byte ptr [rax], al
00001939  0000                   add byte ptr [rax], al
0000193B  0000                   add byte ptr [rax], al
0000193D  0000                   add byte ptr [rax], al
0000193F  0000                   add byte ptr [rax], al
00001941  0000                   add byte ptr [rax], al
00001943  0000                   add byte ptr [rax], al
00001945  0000                   add byte ptr [rax], al
00001947  0000                   add byte ptr [rax], al
00001949  0000                   add byte ptr [rax], al
0000194B  0000                   add byte ptr [rax], al
0000194D  0000                   add byte ptr [rax], al
0000194F  0000                   add byte ptr [rax], al
00001951  0000                   add byte ptr [rax], al
00001953  0000                   add byte ptr [rax], al
00001955  0000                   add byte ptr [rax], al
00001957  0000                   add byte ptr [rax], al
00001959  0000                   add byte ptr [rax], al
0000195B  0000                   add byte ptr [rax], al
0000195D  0000                   add byte ptr [rax], al
0000195F  0000                   add byte ptr [rax], al
00001961  0000                   add byte ptr [rax], al
00001963  0000                   add byte ptr [rax], al
00001965  0000                   add byte ptr [rax], al
00001967  0000                   add byte ptr [rax], al
00001969  0000                   add byte ptr [rax], al
0000196B  0000                   add byte ptr [rax], al
0000196D  0000                   add byte ptr [rax], al
0000196F  0000                   add byte ptr [rax], al
00001971  0000                   add byte ptr [rax], al
00001973  0000                   add byte ptr [rax], al
00001975  0000                   add byte ptr [rax], al
00001977  0000                   add byte ptr [rax], al
00001979  0000                   add byte ptr [rax], al
0000197B  0000                   add byte ptr [rax], al
0000197D  0000                   add byte ptr [rax], al
0000197F  0000                   add byte ptr [rax], al
00001981  0000                   add byte ptr [rax], al
00001983  0000                   add byte ptr [rax], al
00001985  0000                   add byte ptr [rax], al
00001987  0000                   add byte ptr [rax], al
00001989  0000                   add byte ptr [rax], al
0000198B  0000                   add byte ptr [rax], al
0000198D  0000                   add byte ptr [rax], al
0000198F  0000                   add byte ptr [rax], al
00001991  0000                   add byte ptr [rax], al
00001993  0000                   add byte ptr [rax], al
00001995  0000                   add byte ptr [rax], al
00001997  0000                   add byte ptr [rax], al
00001999  0000                   add byte ptr [rax], al
0000199B  0000                   add byte ptr [rax], al
0000199D  0000                   add byte ptr [rax], al
0000199F  0000                   add byte ptr [rax], al
000019A1  0000                   add byte ptr [rax], al
000019A3  0000                   add byte ptr [rax], al
000019A5  0000                   add byte ptr [rax], al
000019A7  0000                   add byte ptr [rax], al
000019A9  0000                   add byte ptr [rax], al
000019AB  0000                   add byte ptr [rax], al
000019AD  0000                   add byte ptr [rax], al
000019AF  0000                   add byte ptr [rax], al
000019B1  0000                   add byte ptr [rax], al
000019B3  0000                   add byte ptr [rax], al
000019B5  0000                   add byte ptr [rax], al
000019B7  0000                   add byte ptr [rax], al
000019B9  0000                   add byte ptr [rax], al
000019BB  0000                   add byte ptr [rax], al
000019BD  0000                   add byte ptr [rax], al
000019BF  0000                   add byte ptr [rax], al
000019C1  0000                   add byte ptr [rax], al
000019C3  0000                   add byte ptr [rax], al
000019C5  0000                   add byte ptr [rax], al
000019C7  0000                   add byte ptr [rax], al
000019C9  0000                   add byte ptr [rax], al
000019CB  0000                   add byte ptr [rax], al
000019CD  0000                   add byte ptr [rax], al
000019CF  0000                   add byte ptr [rax], al
000019D1  0000                   add byte ptr [rax], al
000019D3  0000                   add byte ptr [rax], al
000019D5  0000                   add byte ptr [rax], al
000019D7  0000                   add byte ptr [rax], al
000019D9  0000                   add byte ptr [rax], al
000019DB  0000                   add byte ptr [rax], al
000019DD  0000                   add byte ptr [rax], al
000019DF  0000                   add byte ptr [rax], al
000019E1  0000                   add byte ptr [rax], al
000019E3  0000                   add byte ptr [rax], al
000019E5  0000                   add byte ptr [rax], al
000019E7  0000                   add byte ptr [rax], al
000019E9  0000                   add byte ptr [rax], al
000019EB  0000                   add byte ptr [rax], al
000019ED  0000                   add byte ptr [rax], al
000019EF  0000                   add byte ptr [rax], al
000019F1  0000                   add byte ptr [rax], al
000019F3  0000                   add byte ptr [rax], al
000019F5  0000                   add byte ptr [rax], al
000019F7  0000                   add byte ptr [rax], al
000019F9  0000                   add byte ptr [rax], al
000019FB  0000                   add byte ptr [rax], al
000019FD  0000                   add byte ptr [rax], al
000019FF  0000                   add byte ptr [rax], al
00001A01  0000                   add byte ptr [rax], al
00001A03  0000                   add byte ptr [rax], al
00001A05  0000                   add byte ptr [rax], al
00001A07  0000                   add byte ptr [rax], al
00001A09  0000                   add byte ptr [rax], al
00001A0B  0000                   add byte ptr [rax], al
00001A0D  0000                   add byte ptr [rax], al
00001A0F  0000                   add byte ptr [rax], al
00001A11  0000                   add byte ptr [rax], al
00001A13  0000                   add byte ptr [rax], al
00001A15  0000                   add byte ptr [rax], al
00001A17  0000                   add byte ptr [rax], al
00001A19  0000                   add byte ptr [rax], al
00001A1B  0000                   add byte ptr [rax], al
00001A1D  0000                   add byte ptr [rax], al
00001A1F  0000                   add byte ptr [rax], al
00001A21  0000                   add byte ptr [rax], al
00001A23  0000                   add byte ptr [rax], al
00001A25  0000                   add byte ptr [rax], al
00001A27  0000                   add byte ptr [rax], al
00001A29  0000                   add byte ptr [rax], al
00001A2B  0000                   add byte ptr [rax], al
00001A2D  0000                   add byte ptr [rax], al
00001A2F  0000                   add byte ptr [rax], al
00001A31  0000                   add byte ptr [rax], al
00001A33  0000                   add byte ptr [rax], al
00001A35  0000                   add byte ptr [rax], al
00001A37  0000                   add byte ptr [rax], al
00001A39  0000                   add byte ptr [rax], al
00001A3B  0000                   add byte ptr [rax], al
00001A3D  0000                   add byte ptr [rax], al
00001A3F  0000                   add byte ptr [rax], al
00001A41  0000                   add byte ptr [rax], al
00001A43  0000                   add byte ptr [rax], al
00001A45  0000                   add byte ptr [rax], al
00001A47  0000                   add byte ptr [rax], al
00001A49  0000                   add byte ptr [rax], al
00001A4B  0000                   add byte ptr [rax], al
00001A4D  0000                   add byte ptr [rax], al
00001A4F  0000                   add byte ptr [rax], al
00001A51  0000                   add byte ptr [rax], al
00001A53  0000                   add byte ptr [rax], al
00001A55  0000                   add byte ptr [rax], al
00001A57  0000                   add byte ptr [rax], al
00001A59  0000                   add byte ptr [rax], al
00001A5B  0000                   add byte ptr [rax], al
00001A5D  0000                   add byte ptr [rax], al
00001A5F  0000                   add byte ptr [rax], al
00001A61  0000                   add byte ptr [rax], al
00001A63  0000                   add byte ptr [rax], al
00001A65  0000                   add byte ptr [rax], al
00001A67  0000                   add byte ptr [rax], al
00001A69  0000                   add byte ptr [rax], al
00001A6B  0000                   add byte ptr [rax], al
00001A6D  0000                   add byte ptr [rax], al
00001A6F  0000                   add byte ptr [rax], al
00001A71  0000                   add byte ptr [rax], al
00001A73  0000                   add byte ptr [rax], al
00001A75  0000                   add byte ptr [rax], al
00001A77  0000                   add byte ptr [rax], al
00001A79  0000                   add byte ptr [rax], al
00001A7B  0000                   add byte ptr [rax], al
00001A7D  0000                   add byte ptr [rax], al
00001A7F  0000                   add byte ptr [rax], al
00001A81  0000                   add byte ptr [rax], al
00001A83  0000                   add byte ptr [rax], al
00001A85  0000                   add byte ptr [rax], al
00001A87  0000                   add byte ptr [rax], al
00001A89  0000                   add byte ptr [rax], al
00001A8B  0000                   add byte ptr [rax], al
00001A8D  0000                   add byte ptr [rax], al
00001A8F  0000                   add byte ptr [rax], al
00001A91  0000                   add byte ptr [rax], al
00001A93  0000                   add byte ptr [rax], al
00001A95  0000                   add byte ptr [rax], al
00001A97  0000                   add byte ptr [rax], al
00001A99  0000                   add byte ptr [rax], al
00001A9B  0000                   add byte ptr [rax], al
00001A9D  0000                   add byte ptr [rax], al
00001A9F  0000                   add byte ptr [rax], al
00001AA1  0000                   add byte ptr [rax], al
00001AA3  0000                   add byte ptr [rax], al
00001AA5  0000                   add byte ptr [rax], al
00001AA7  0000                   add byte ptr [rax], al
00001AA9  0000                   add byte ptr [rax], al
00001AAB  0000                   add byte ptr [rax], al
00001AAD  0000                   add byte ptr [rax], al
00001AAF  0000                   add byte ptr [rax], al
00001AB1  0000                   add byte ptr [rax], al
00001AB3  0000                   add byte ptr [rax], al
00001AB5  0000                   add byte ptr [rax], al
00001AB7  0000                   add byte ptr [rax], al
00001AB9  0000                   add byte ptr [rax], al
00001ABB  0000                   add byte ptr [rax], al
00001ABD  0000                   add byte ptr [rax], al
00001ABF  0000                   add byte ptr [rax], al
00001AC1  0000                   add byte ptr [rax], al
00001AC3  0000                   add byte ptr [rax], al
00001AC5  0000                   add byte ptr [rax], al
00001AC7  0000                   add byte ptr [rax], al
00001AC9  0000                   add byte ptr [rax], al
00001ACB  0000                   add byte ptr [rax], al
00001ACD  0000                   add byte ptr [rax], al
00001ACF  0000                   add byte ptr [rax], al
00001AD1  0000                   add byte ptr [rax], al
00001AD3  0000                   add byte ptr [rax], al
00001AD5  0000                   add byte ptr [rax], al
00001AD7  0000                   add byte ptr [rax], al
00001AD9  0000                   add byte ptr [rax], al
00001ADB  0000                   add byte ptr [rax], al
00001ADD  0000                   add byte ptr [rax], al
00001ADF  0000                   add byte ptr [rax], al
00001AE1  0000                   add byte ptr [rax], al
00001AE3  0000                   add byte ptr [rax], al
00001AE5  0000                   add byte ptr [rax], al
00001AE7  0000                   add byte ptr [rax], al
00001AE9  0000                   add byte ptr [rax], al
00001AEB  0000                   add byte ptr [rax], al
00001AED  0000                   add byte ptr [rax], al
00001AEF  0000                   add byte ptr [rax], al
00001AF1  0000                   add byte ptr [rax], al
00001AF3  0000                   add byte ptr [rax], al
00001AF5  0000                   add byte ptr [rax], al
00001AF7  0000                   add byte ptr [rax], al
00001AF9  0000                   add byte ptr [rax], al
00001AFB  0000                   add byte ptr [rax], al
00001AFD  0000                   add byte ptr [rax], al
00001AFF  0000                   add byte ptr [rax], al
00001B01  0000                   add byte ptr [rax], al
00001B03  0000                   add byte ptr [rax], al
00001B05  0000                   add byte ptr [rax], al
00001B07  0000                   add byte ptr [rax], al
00001B09  0000                   add byte ptr [rax], al
00001B0B  0000                   add byte ptr [rax], al
00001B0D  0000                   add byte ptr [rax], al
00001B0F  0000                   add byte ptr [rax], al
00001B11  0000                   add byte ptr [rax], al
00001B13  0000                   add byte ptr [rax], al
00001B15  0000                   add byte ptr [rax], al
00001B17  0000                   add byte ptr [rax], al
00001B19  0000                   add byte ptr [rax], al
00001B1B  0000                   add byte ptr [rax], al
00001B1D  0000                   add byte ptr [rax], al
00001B1F  0000                   add byte ptr [rax], al
00001B21  0000                   add byte ptr [rax], al
00001B23  0000                   add byte ptr [rax], al
00001B25  0000                   add byte ptr [rax], al
00001B27  0000                   add byte ptr [rax], al
00001B29  0000                   add byte ptr [rax], al
00001B2B  0000                   add byte ptr [rax], al
00001B2D  0000                   add byte ptr [rax], al
00001B2F  0000                   add byte ptr [rax], al
00001B31  0000                   add byte ptr [rax], al
00001B33  0000                   add byte ptr [rax], al
00001B35  0000                   add byte ptr [rax], al
00001B37  0000                   add byte ptr [rax], al
00001B39  0000                   add byte ptr [rax], al
00001B3B  0000                   add byte ptr [rax], al
00001B3D  0000                   add byte ptr [rax], al
00001B3F  0000                   add byte ptr [rax], al
00001B41  0000                   add byte ptr [rax], al
00001B43  0000                   add byte ptr [rax], al
00001B45  0000                   add byte ptr [rax], al
00001B47  0000                   add byte ptr [rax], al
00001B49  0000                   add byte ptr [rax], al
00001B4B  0000                   add byte ptr [rax], al
00001B4D  0000                   add byte ptr [rax], al
00001B4F  0000                   add byte ptr [rax], al
00001B51  0000                   add byte ptr [rax], al
00001B53  0000                   add byte ptr [rax], al
00001B55  0000                   add byte ptr [rax], al
00001B57  0000                   add byte ptr [rax], al
00001B59  0000                   add byte ptr [rax], al
00001B5B  0000                   add byte ptr [rax], al
00001B5D  0000                   add byte ptr [rax], al
00001B5F  0000                   add byte ptr [rax], al
00001B61  0000                   add byte ptr [rax], al
00001B63  0000                   add byte ptr [rax], al
00001B65  0000                   add byte ptr [rax], al
00001B67  0000                   add byte ptr [rax], al
00001B69  0000                   add byte ptr [rax], al
00001B6B  0000                   add byte ptr [rax], al
00001B6D  0000                   add byte ptr [rax], al
00001B6F  0000                   add byte ptr [rax], al
00001B71  0000                   add byte ptr [rax], al
00001B73  0000                   add byte ptr [rax], al
00001B75  0000                   add byte ptr [rax], al
00001B77  0000                   add byte ptr [rax], al
00001B79  0000                   add byte ptr [rax], al
00001B7B  0000                   add byte ptr [rax], al
00001B7D  0000                   add byte ptr [rax], al
00001B7F  0000                   add byte ptr [rax], al
00001B81  0000                   add byte ptr [rax], al
00001B83  0000                   add byte ptr [rax], al
00001B85  0000                   add byte ptr [rax], al
00001B87  0000                   add byte ptr [rax], al
00001B89  0000                   add byte ptr [rax], al
00001B8B  0000                   add byte ptr [rax], al
00001B8D  0000                   add byte ptr [rax], al
00001B8F  0000                   add byte ptr [rax], al
00001B91  0000                   add byte ptr [rax], al
00001B93  0000                   add byte ptr [rax], al
00001B95  0000                   add byte ptr [rax], al
00001B97  0000                   add byte ptr [rax], al
00001B99  0000                   add byte ptr [rax], al
00001B9B  0000                   add byte ptr [rax], al
00001B9D  0000                   add byte ptr [rax], al
00001B9F  0000                   add byte ptr [rax], al
00001BA1  0000                   add byte ptr [rax], al
00001BA3  0000                   add byte ptr [rax], al
00001BA5  0000                   add byte ptr [rax], al
00001BA7  0000                   add byte ptr [rax], al
00001BA9  0000                   add byte ptr [rax], al
00001BAB  0000                   add byte ptr [rax], al
00001BAD  0000                   add byte ptr [rax], al
00001BAF  0000                   add byte ptr [rax], al
00001BB1  0000                   add byte ptr [rax], al
00001BB3  0000                   add byte ptr [rax], al
00001BB5  0000                   add byte ptr [rax], al
00001BB7  0000                   add byte ptr [rax], al
00001BB9  0000                   add byte ptr [rax], al
00001BBB  0000                   add byte ptr [rax], al
00001BBD  0000                   add byte ptr [rax], al
00001BBF  0000                   add byte ptr [rax], al
00001BC1  0000                   add byte ptr [rax], al
00001BC3  0000                   add byte ptr [rax], al
00001BC5  0000                   add byte ptr [rax], al
00001BC7  0000                   add byte ptr [rax], al
00001BC9  0000                   add byte ptr [rax], al
00001BCB  0000                   add byte ptr [rax], al
00001BCD  0000                   add byte ptr [rax], al
00001BCF  0000                   add byte ptr [rax], al
00001BD1  0000                   add byte ptr [rax], al
00001BD3  0000                   add byte ptr [rax], al
00001BD5  0000                   add byte ptr [rax], al
00001BD7  0000                   add byte ptr [rax], al
00001BD9  0000                   add byte ptr [rax], al
00001BDB  0000                   add byte ptr [rax], al
00001BDD  0000                   add byte ptr [rax], al
00001BDF  0000                   add byte ptr [rax], al
00001BE1  0000                   add byte ptr [rax], al
00001BE3  0000                   add byte ptr [rax], al
00001BE5  0000                   add byte ptr [rax], al
00001BE7  0000                   add byte ptr [rax], al
00001BE9  0000                   add byte ptr [rax], al
00001BEB  0000                   add byte ptr [rax], al
00001BED  0000                   add byte ptr [rax], al
00001BEF  0000                   add byte ptr [rax], al
00001BF1  0000                   add byte ptr [rax], al
00001BF3  0000                   add byte ptr [rax], al
00001BF5  0000                   add byte ptr [rax], al
00001BF7  0000                   add byte ptr [rax], al
00001BF9  0000                   add byte ptr [rax], al
00001BFB  0000                   add byte ptr [rax], al
00001BFD  0000                   add byte ptr [rax], al
00001BFF  0000                   add byte ptr [rax], al
00001C01  0000                   add byte ptr [rax], al
00001C03  0000                   add byte ptr [rax], al
00001C05  0000                   add byte ptr [rax], al
00001C07  0000                   add byte ptr [rax], al
00001C09  0000                   add byte ptr [rax], al
00001C0B  0000                   add byte ptr [rax], al
00001C0D  0000                   add byte ptr [rax], al
00001C0F  0000                   add byte ptr [rax], al
00001C11  0000                   add byte ptr [rax], al
00001C13  0000                   add byte ptr [rax], al
00001C15  0000                   add byte ptr [rax], al
00001C17  0000                   add byte ptr [rax], al
00001C19  0000                   add byte ptr [rax], al
00001C1B  0000                   add byte ptr [rax], al
00001C1D  0000                   add byte ptr [rax], al
00001C1F  0000                   add byte ptr [rax], al
00001C21  0000                   add byte ptr [rax], al
00001C23  0000                   add byte ptr [rax], al
00001C25  0000                   add byte ptr [rax], al
00001C27  0000                   add byte ptr [rax], al
00001C29  0000                   add byte ptr [rax], al
00001C2B  0000                   add byte ptr [rax], al
00001C2D  0000                   add byte ptr [rax], al
00001C2F  0000                   add byte ptr [rax], al
00001C31  0000                   add byte ptr [rax], al
00001C33  0000                   add byte ptr [rax], al
00001C35  0000                   add byte ptr [rax], al
00001C37  0000                   add byte ptr [rax], al
00001C39  0000                   add byte ptr [rax], al
00001C3B  0000                   add byte ptr [rax], al
00001C3D  0000                   add byte ptr [rax], al
00001C3F  0000                   add byte ptr [rax], al
00001C41  0000                   add byte ptr [rax], al
00001C43  0000                   add byte ptr [rax], al
00001C45  0000                   add byte ptr [rax], al
00001C47  0000                   add byte ptr [rax], al
00001C49  0000                   add byte ptr [rax], al
00001C4B  0000                   add byte ptr [rax], al
00001C4D  0000                   add byte ptr [rax], al
00001C4F  0000                   add byte ptr [rax], al
00001C51  0000                   add byte ptr [rax], al
00001C53  0000                   add byte ptr [rax], al
00001C55  0000                   add byte ptr [rax], al
00001C57  0000                   add byte ptr [rax], al
00001C59  0000                   add byte ptr [rax], al
00001C5B  0000                   add byte ptr [rax], al
00001C5D  0000                   add byte ptr [rax], al
00001C5F  0000                   add byte ptr [rax], al
00001C61  0000                   add byte ptr [rax], al
00001C63  0000                   add byte ptr [rax], al
00001C65  0000                   add byte ptr [rax], al
00001C67  0000                   add byte ptr [rax], al
00001C69  0000                   add byte ptr [rax], al
00001C6B  0000                   add byte ptr [rax], al
00001C6D  0000                   add byte ptr [rax], al
00001C6F  0000                   add byte ptr [rax], al
00001C71  0000                   add byte ptr [rax], al
00001C73  0000                   add byte ptr [rax], al
00001C75  0000                   add byte ptr [rax], al
00001C77  0000                   add byte ptr [rax], al
00001C79  0000                   add byte ptr [rax], al
00001C7B  0000                   add byte ptr [rax], al
00001C7D  0000                   add byte ptr [rax], al
00001C7F  0000                   add byte ptr [rax], al
00001C81  0000                   add byte ptr [rax], al
00001C83  0000                   add byte ptr [rax], al
00001C85  0000                   add byte ptr [rax], al
00001C87  0000                   add byte ptr [rax], al
00001C89  0000                   add byte ptr [rax], al
00001C8B  0000                   add byte ptr [rax], al
00001C8D  0000                   add byte ptr [rax], al
00001C8F  0000                   add byte ptr [rax], al
00001C91  0000                   add byte ptr [rax], al
00001C93  0000                   add byte ptr [rax], al
00001C95  0000                   add byte ptr [rax], al
00001C97  0000                   add byte ptr [rax], al
00001C99  0000                   add byte ptr [rax], al
00001C9B  0000                   add byte ptr [rax], al
00001C9D  0000                   add byte ptr [rax], al
00001C9F  0000                   add byte ptr [rax], al
00001CA1  0000                   add byte ptr [rax], al
00001CA3  0000                   add byte ptr [rax], al
00001CA5  0000                   add byte ptr [rax], al
00001CA7  0000                   add byte ptr [rax], al
00001CA9  0000                   add byte ptr [rax], al
00001CAB  0000                   add byte ptr [rax], al
00001CAD  0000                   add byte ptr [rax], al
00001CAF  0000                   add byte ptr [rax], al
00001CB1  0000                   add byte ptr [rax], al
00001CB3  0000                   add byte ptr [rax], al
00001CB5  0000                   add byte ptr [rax], al
00001CB7  0000                   add byte ptr [rax], al
00001CB9  0000                   add byte ptr [rax], al
00001CBB  0000                   add byte ptr [rax], al
00001CBD  0000                   add byte ptr [rax], al
00001CBF  0000                   add byte ptr [rax], al
00001CC1  0000                   add byte ptr [rax], al
00001CC3  0000                   add byte ptr [rax], al
00001CC5  0000                   add byte ptr [rax], al
00001CC7  0000                   add byte ptr [rax], al
00001CC9  0000                   add byte ptr [rax], al
00001CCB  0000                   add byte ptr [rax], al
00001CCD  0000                   add byte ptr [rax], al
00001CCF  0000                   add byte ptr [rax], al
00001CD1  0000                   add byte ptr [rax], al
00001CD3  0000                   add byte ptr [rax], al
00001CD5  0000                   add byte ptr [rax], al
00001CD7  0000                   add byte ptr [rax], al
00001CD9  0000                   add byte ptr [rax], al
00001CDB  0000                   add byte ptr [rax], al
00001CDD  0000                   add byte ptr [rax], al
00001CDF  0000                   add byte ptr [rax], al
00001CE1  0000                   add byte ptr [rax], al
00001CE3  0000                   add byte ptr [rax], al
00001CE5  0000                   add byte ptr [rax], al
00001CE7  0000                   add byte ptr [rax], al
00001CE9  0000                   add byte ptr [rax], al
00001CEB  0000                   add byte ptr [rax], al
00001CED  0000                   add byte ptr [rax], al
00001CEF  0000                   add byte ptr [rax], al
00001CF1  0000                   add byte ptr [rax], al
00001CF3  0000                   add byte ptr [rax], al
00001CF5  0000                   add byte ptr [rax], al
00001CF7  0000                   add byte ptr [rax], al
00001CF9  0000                   add byte ptr [rax], al
00001CFB  0000                   add byte ptr [rax], al
00001CFD  0000                   add byte ptr [rax], al
00001CFF  0000                   add byte ptr [rax], al
00001D01  0000                   add byte ptr [rax], al
00001D03  0000                   add byte ptr [rax], al
00001D05  0000                   add byte ptr [rax], al
00001D07  0000                   add byte ptr [rax], al
00001D09  0000                   add byte ptr [rax], al
00001D0B  0000                   add byte ptr [rax], al
00001D0D  0000                   add byte ptr [rax], al
00001D0F  0000                   add byte ptr [rax], al
00001D11  0000                   add byte ptr [rax], al
00001D13  0000                   add byte ptr [rax], al
00001D15  0000                   add byte ptr [rax], al
00001D17  0000                   add byte ptr [rax], al
00001D19  0000                   add byte ptr [rax], al
00001D1B  0000                   add byte ptr [rax], al
00001D1D  0000                   add byte ptr [rax], al
00001D1F  0000                   add byte ptr [rax], al
00001D21  0000                   add byte ptr [rax], al
00001D23  0000                   add byte ptr [rax], al
00001D25  0000                   add byte ptr [rax], al
00001D27  0000                   add byte ptr [rax], al
00001D29  0000                   add byte ptr [rax], al
00001D2B  0000                   add byte ptr [rax], al
00001D2D  0000                   add byte ptr [rax], al
00001D2F  0000                   add byte ptr [rax], al
00001D31  0000                   add byte ptr [rax], al
00001D33  0000                   add byte ptr [rax], al
00001D35  0000                   add byte ptr [rax], al
00001D37  0000                   add byte ptr [rax], al
00001D39  0000                   add byte ptr [rax], al
00001D3B  0000                   add byte ptr [rax], al
00001D3D  0000                   add byte ptr [rax], al
00001D3F  0000                   add byte ptr [rax], al
00001D41  0000                   add byte ptr [rax], al
00001D43  0000                   add byte ptr [rax], al
00001D45  0000                   add byte ptr [rax], al
00001D47  0000                   add byte ptr [rax], al
00001D49  0000                   add byte ptr [rax], al
00001D4B  0000                   add byte ptr [rax], al
00001D4D  0000                   add byte ptr [rax], al
00001D4F  0000                   add byte ptr [rax], al
00001D51  0000                   add byte ptr [rax], al
00001D53  0000                   add byte ptr [rax], al
00001D55  0000                   add byte ptr [rax], al
00001D57  0000                   add byte ptr [rax], al
00001D59  0000                   add byte ptr [rax], al
00001D5B  0000                   add byte ptr [rax], al
00001D5D  0000                   add byte ptr [rax], al
00001D5F  0000                   add byte ptr [rax], al
00001D61  0000                   add byte ptr [rax], al
00001D63  0000                   add byte ptr [rax], al
00001D65  0000                   add byte ptr [rax], al
00001D67  0000                   add byte ptr [rax], al
00001D69  0000                   add byte ptr [rax], al
00001D6B  0000                   add byte ptr [rax], al
00001D6D  0000                   add byte ptr [rax], al
00001D6F  0000                   add byte ptr [rax], al
00001D71  0000                   add byte ptr [rax], al
00001D73  0000                   add byte ptr [rax], al
00001D75  0000                   add byte ptr [rax], al
00001D77  0000                   add byte ptr [rax], al
00001D79  0000                   add byte ptr [rax], al
00001D7B  0000                   add byte ptr [rax], al
00001D7D  0000                   add byte ptr [rax], al
00001D7F  0000                   add byte ptr [rax], al
00001D81  0000                   add byte ptr [rax], al
00001D83  0000                   add byte ptr [rax], al
00001D85  0000                   add byte ptr [rax], al
00001D87  0000                   add byte ptr [rax], al
00001D89  0000                   add byte ptr [rax], al
00001D8B  0000                   add byte ptr [rax], al
00001D8D  0000                   add byte ptr [rax], al
00001D8F  0000                   add byte ptr [rax], al
00001D91  0000                   add byte ptr [rax], al
00001D93  0000                   add byte ptr [rax], al
00001D95  0000                   add byte ptr [rax], al
00001D97  0000                   add byte ptr [rax], al
00001D99  0000                   add byte ptr [rax], al
00001D9B  0000                   add byte ptr [rax], al
00001D9D  0000                   add byte ptr [rax], al
00001D9F  0000                   add byte ptr [rax], al
00001DA1  0000                   add byte ptr [rax], al
00001DA3  0000                   add byte ptr [rax], al
00001DA5  0000                   add byte ptr [rax], al
00001DA7  0000                   add byte ptr [rax], al
00001DA9  0000                   add byte ptr [rax], al
00001DAB  0000                   add byte ptr [rax], al
00001DAD  0000                   add byte ptr [rax], al
00001DAF  0000                   add byte ptr [rax], al
00001DB1  0000                   add byte ptr [rax], al
00001DB3  0000                   add byte ptr [rax], al
00001DB5  0000                   add byte ptr [rax], al
00001DB7  0000                   add byte ptr [rax], al
00001DB9  0000                   add byte ptr [rax], al
00001DBB  0000                   add byte ptr [rax], al
00001DBD  0000                   add byte ptr [rax], al
00001DBF  0000                   add byte ptr [rax], al
00001DC1  0000                   add byte ptr [rax], al
00001DC3  0000                   add byte ptr [rax], al
00001DC5  0000                   add byte ptr [rax], al
00001DC7  0000                   add byte ptr [rax], al
00001DC9  0000                   add byte ptr [rax], al
00001DCB  0000                   add byte ptr [rax], al
00001DCD  0000                   add byte ptr [rax], al
00001DCF  0000                   add byte ptr [rax], al
00001DD1  0000                   add byte ptr [rax], al
00001DD3  0000                   add byte ptr [rax], al
00001DD5  0000                   add byte ptr [rax], al
00001DD7  0000                   add byte ptr [rax], al
00001DD9  0000                   add byte ptr [rax], al
00001DDB  0000                   add byte ptr [rax], al
00001DDD  0000                   add byte ptr [rax], al
00001DDF  0000                   add byte ptr [rax], al
00001DE1  0000                   add byte ptr [rax], al
00001DE3  0000                   add byte ptr [rax], al
00001DE5  0000                   add byte ptr [rax], al
00001DE7  0000                   add byte ptr [rax], al
00001DE9  0000                   add byte ptr [rax], al
00001DEB  0000                   add byte ptr [rax], al
00001DED  0000                   add byte ptr [rax], al
00001DEF  0000                   add byte ptr [rax], al
00001DF1  0000                   add byte ptr [rax], al
00001DF3  0000                   add byte ptr [rax], al
00001DF5  0000                   add byte ptr [rax], al
00001DF7  0000                   add byte ptr [rax], al
00001DF9  0000                   add byte ptr [rax], al
00001DFB  0000                   add byte ptr [rax], al
00001DFD  0000                   add byte ptr [rax], al
00001DFF  0000                   add byte ptr [rax], al
00001E01  0000                   add byte ptr [rax], al
00001E03  0000                   add byte ptr [rax], al
00001E05  0000                   add byte ptr [rax], al
00001E07  0000                   add byte ptr [rax], al
00001E09  0000                   add byte ptr [rax], al
00001E0B  0000                   add byte ptr [rax], al
00001E0D  0000                   add byte ptr [rax], al
00001E0F  0000                   add byte ptr [rax], al
00001E11  0000                   add byte ptr [rax], al
00001E13  0000                   add byte ptr [rax], al
00001E15  0000                   add byte ptr [rax], al
00001E17  0000                   add byte ptr [rax], al
00001E19  0000                   add byte ptr [rax], al
00001E1B  0000                   add byte ptr [rax], al
00001E1D  0000                   add byte ptr [rax], al
00001E1F  0000                   add byte ptr [rax], al
00001E21  0000                   add byte ptr [rax], al
00001E23  0000                   add byte ptr [rax], al
00001E25  0000                   add byte ptr [rax], al
00001E27  0000                   add byte ptr [rax], al
00001E29  0000                   add byte ptr [rax], al
00001E2B  0000                   add byte ptr [rax], al
00001E2D  0000                   add byte ptr [rax], al
00001E2F  0000                   add byte ptr [rax], al
00001E31  0000                   add byte ptr [rax], al
00001E33  0000                   add byte ptr [rax], al
00001E35  0000                   add byte ptr [rax], al
00001E37  0000                   add byte ptr [rax], al
00001E39  0000                   add byte ptr [rax], al
00001E3B  0000                   add byte ptr [rax], al
00001E3D  0000                   add byte ptr [rax], al
00001E3F  0000                   add byte ptr [rax], al
00001E41  0000                   add byte ptr [rax], al
00001E43  0000                   add byte ptr [rax], al
00001E45  0000                   add byte ptr [rax], al
00001E47  0000                   add byte ptr [rax], al
00001E49  0000                   add byte ptr [rax], al
00001E4B  0000                   add byte ptr [rax], al
00001E4D  0000                   add byte ptr [rax], al
00001E4F  0000                   add byte ptr [rax], al
00001E51  0000                   add byte ptr [rax], al
00001E53  0000                   add byte ptr [rax], al
00001E55  0000                   add byte ptr [rax], al
00001E57  0000                   add byte ptr [rax], al
00001E59  0000                   add byte ptr [rax], al
00001E5B  0000                   add byte ptr [rax], al
00001E5D  0000                   add byte ptr [rax], al
00001E5F  0000                   add byte ptr [rax], al
00001E61  0000                   add byte ptr [rax], al
00001E63  0000                   add byte ptr [rax], al
00001E65  0000                   add byte ptr [rax], al
00001E67  0000                   add byte ptr [rax], al
00001E69  0000                   add byte ptr [rax], al
00001E6B  0000                   add byte ptr [rax], al
00001E6D  0000                   add byte ptr [rax], al
00001E6F  0000                   add byte ptr [rax], al
00001E71  0000                   add byte ptr [rax], al
00001E73  0000                   add byte ptr [rax], al
00001E75  0000                   add byte ptr [rax], al
00001E77  0000                   add byte ptr [rax], al
00001E79  0000                   add byte ptr [rax], al
00001E7B  0000                   add byte ptr [rax], al
00001E7D  0000                   add byte ptr [rax], al
00001E7F  0000                   add byte ptr [rax], al
00001E81  0000                   add byte ptr [rax], al
00001E83  0000                   add byte ptr [rax], al
00001E85  0000                   add byte ptr [rax], al
00001E87  0000                   add byte ptr [rax], al
00001E89  0000                   add byte ptr [rax], al
00001E8B  0000                   add byte ptr [rax], al
00001E8D  0000                   add byte ptr [rax], al
00001E8F  0000                   add byte ptr [rax], al
00001E91  0000                   add byte ptr [rax], al
00001E93  0000                   add byte ptr [rax], al
00001E95  0000                   add byte ptr [rax], al
00001E97  0000                   add byte ptr [rax], al
00001E99  0000                   add byte ptr [rax], al
00001E9B  0000                   add byte ptr [rax], al
00001E9D  0000                   add byte ptr [rax], al
00001E9F  0000                   add byte ptr [rax], al
00001EA1  0000                   add byte ptr [rax], al
00001EA3  0000                   add byte ptr [rax], al
00001EA5  0000                   add byte ptr [rax], al
00001EA7  0000                   add byte ptr [rax], al
00001EA9  0000                   add byte ptr [rax], al
00001EAB  0000                   add byte ptr [rax], al
00001EAD  0000                   add byte ptr [rax], al
00001EAF  0000                   add byte ptr [rax], al
00001EB1  0000                   add byte ptr [rax], al
00001EB3  0000                   add byte ptr [rax], al
00001EB5  0000                   add byte ptr [rax], al
00001EB7  0000                   add byte ptr [rax], al
00001EB9  0000                   add byte ptr [rax], al
00001EBB  0000                   add byte ptr [rax], al
00001EBD  0000                   add byte ptr [rax], al
00001EBF  0000                   add byte ptr [rax], al
00001EC1  0000                   add byte ptr [rax], al
00001EC3  0000                   add byte ptr [rax], al
00001EC5  0000                   add byte ptr [rax], al
00001EC7  0000                   add byte ptr [rax], al
00001EC9  0000                   add byte ptr [rax], al
00001ECB  0000                   add byte ptr [rax], al
00001ECD  0000                   add byte ptr [rax], al
00001ECF  0000                   add byte ptr [rax], al
00001ED1  0000                   add byte ptr [rax], al
00001ED3  0000                   add byte ptr [rax], al
00001ED5  0000                   add byte ptr [rax], al
00001ED7  0000                   add byte ptr [rax], al
00001ED9  0000                   add byte ptr [rax], al
00001EDB  0000                   add byte ptr [rax], al
00001EDD  0000                   add byte ptr [rax], al
00001EDF  0000                   add byte ptr [rax], al
00001EE1  0000                   add byte ptr [rax], al
00001EE3  0000                   add byte ptr [rax], al
00001EE5  0000                   add byte ptr [rax], al
00001EE7  0000                   add byte ptr [rax], al
00001EE9  0000                   add byte ptr [rax], al
00001EEB  0000                   add byte ptr [rax], al
00001EED  0000                   add byte ptr [rax], al
00001EEF  0000                   add byte ptr [rax], al
00001EF1  0000                   add byte ptr [rax], al
00001EF3  0000                   add byte ptr [rax], al
00001EF5  0000                   add byte ptr [rax], al
00001EF7  0000                   add byte ptr [rax], al
00001EF9  0000                   add byte ptr [rax], al
00001EFB  0000                   add byte ptr [rax], al
00001EFD  0000                   add byte ptr [rax], al
00001EFF  0000                   add byte ptr [rax], al
00001F01  0000                   add byte ptr [rax], al
00001F03  0000                   add byte ptr [rax], al
00001F05  0000                   add byte ptr [rax], al
00001F07  0000                   add byte ptr [rax], al
00001F09  0000                   add byte ptr [rax], al
00001F0B  0000                   add byte ptr [rax], al
00001F0D  0000                   add byte ptr [rax], al
00001F0F  0000                   add byte ptr [rax], al
00001F11  0000                   add byte ptr [rax], al
00001F13  0000                   add byte ptr [rax], al
00001F15  0000                   add byte ptr [rax], al
00001F17  0000                   add byte ptr [rax], al
00001F19  0000                   add byte ptr [rax], al
00001F1B  0000                   add byte ptr [rax], al
00001F1D  0000                   add byte ptr [rax], al
00001F1F  0000                   add byte ptr [rax], al
00001F21  0000                   add byte ptr [rax], al
00001F23  0000                   add byte ptr [rax], al
00001F25  0000                   add byte ptr [rax], al
00001F27  0000                   add byte ptr [rax], al
00001F29  0000                   add byte ptr [rax], al
00001F2B  0000                   add byte ptr [rax], al
00001F2D  0000                   add byte ptr [rax], al
00001F2F  0000                   add byte ptr [rax], al
00001F31  0000                   add byte ptr [rax], al
00001F33  0000                   add byte ptr [rax], al
00001F35  0000                   add byte ptr [rax], al
00001F37  0000                   add byte ptr [rax], al
00001F39  0000                   add byte ptr [rax], al
00001F3B  0000                   add byte ptr [rax], al
00001F3D  0000                   add byte ptr [rax], al
00001F3F  0000                   add byte ptr [rax], al
00001F41  0000                   add byte ptr [rax], al
00001F43  0000                   add byte ptr [rax], al
00001F45  0000                   add byte ptr [rax], al
00001F47  0000                   add byte ptr [rax], al
00001F49  0000                   add byte ptr [rax], al
00001F4B  0000                   add byte ptr [rax], al
00001F4D  0000                   add byte ptr [rax], al
00001F4F  0000                   add byte ptr [rax], al
00001F51  0000                   add byte ptr [rax], al
00001F53  0000                   add byte ptr [rax], al
00001F55  0000                   add byte ptr [rax], al
00001F57  0000                   add byte ptr [rax], al
00001F59  0000                   add byte ptr [rax], al
00001F5B  0000                   add byte ptr [rax], al
00001F5D  0000                   add byte ptr [rax], al
00001F5F  0000                   add byte ptr [rax], al
00001F61  0000                   add byte ptr [rax], al
00001F63  0000                   add byte ptr [rax], al
00001F65  0000                   add byte ptr [rax], al
00001F67  0000                   add byte ptr [rax], al
00001F69  0000                   add byte ptr [rax], al
00001F6B  0000                   add byte ptr [rax], al
00001F6D  0000                   add byte ptr [rax], al
00001F6F  0000                   add byte ptr [rax], al
00001F71  0000                   add byte ptr [rax], al
00001F73  0000                   add byte ptr [rax], al
00001F75  0000                   add byte ptr [rax], al
00001F77  0000                   add byte ptr [rax], al
00001F79  0000                   add byte ptr [rax], al
00001F7B  0000                   add byte ptr [rax], al
00001F7D  0000                   add byte ptr [rax], al
00001F7F  0000                   add byte ptr [rax], al
00001F81  0000                   add byte ptr [rax], al
00001F83  0000                   add byte ptr [rax], al
00001F85  0000                   add byte ptr [rax], al
00001F87  0000                   add byte ptr [rax], al
00001F89  0000                   add byte ptr [rax], al
00001F8B  0000                   add byte ptr [rax], al
00001F8D  0000                   add byte ptr [rax], al
00001F8F  0000                   add byte ptr [rax], al
00001F91  0000                   add byte ptr [rax], al
00001F93  0000                   add byte ptr [rax], al
00001F95  0000                   add byte ptr [rax], al
00001F97  0000                   add byte ptr [rax], al
00001F99  0000                   add byte ptr [rax], al
00001F9B  0000                   add byte ptr [rax], al
00001F9D  0000                   add byte ptr [rax], al
00001F9F  0000                   add byte ptr [rax], al
00001FA1  0000                   add byte ptr [rax], al
00001FA3  0000                   add byte ptr [rax], al
00001FA5  0000                   add byte ptr [rax], al
00001FA7  0000                   add byte ptr [rax], al
00001FA9  0000                   add byte ptr [rax], al
00001FAB  0000                   add byte ptr [rax], al
00001FAD  0000                   add byte ptr [rax], al
00001FAF  0000                   add byte ptr [rax], al
00001FB1  0000                   add byte ptr [rax], al
00001FB3  0000                   add byte ptr [rax], al
00001FB5  0000                   add byte ptr [rax], al
00001FB7  0000                   add byte ptr [rax], al
00001FB9  0000                   add byte ptr [rax], al
00001FBB  0000                   add byte ptr [rax], al
00001FBD  0000                   add byte ptr [rax], al
00001FBF  0000                   add byte ptr [rax], al
00001FC1  0000                   add byte ptr [rax], al
00001FC3  0000                   add byte ptr [rax], al
00001FC5  0000                   add byte ptr [rax], al
00001FC7  0000                   add byte ptr [rax], al
00001FC9  0000                   add byte ptr [rax], al
00001FCB  0000                   add byte ptr [rax], al
00001FCD  0000                   add byte ptr [rax], al
00001FCF  0000                   add byte ptr [rax], al
00001FD1  0000                   add byte ptr [rax], al
00001FD3  0000                   add byte ptr [rax], al
00001FD5  0000                   add byte ptr [rax], al
00001FD7  0000                   add byte ptr [rax], al
00001FD9  0000                   add byte ptr [rax], al
00001FDB  0000                   add byte ptr [rax], al
00001FDD  0000                   add byte ptr [rax], al
00001FDF  0000                   add byte ptr [rax], al
00001FE1  0000                   add byte ptr [rax], al
00001FE3  0000                   add byte ptr [rax], al
00001FE5  0000                   add byte ptr [rax], al
00001FE7  0000                   add byte ptr [rax], al
00001FE9  0000                   add byte ptr [rax], al
00001FEB  0000                   add byte ptr [rax], al
00001FED  0000                   add byte ptr [rax], al
00001FEF  0000                   add byte ptr [rax], al
00001FF1  0000                   add byte ptr [rax], al
00001FF3  0000                   add byte ptr [rax], al
00001FF5  0000                   add byte ptr [rax], al
00001FF7  0000                   add byte ptr [rax], al
00001FF9  0000                   add byte ptr [rax], al
00001FFB  0000                   add byte ptr [rax], al
00001FFD  0000                   add byte ptr [rax], al
00001FFF  004cf239               add byte ptr [rdx + rsi*8 + 0x39], cl
00002003  77d7                   ja 0x1fdc
00002005  93                     xchg ebx, eax