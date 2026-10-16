FFE1BDAC  56                       push esi
FFE1BDAD  8b74240c                 mov esi, dword ptr [esp + 0xc]
FFE1BDB1  e8e3020000               call 0xffe1c099
FFE1BDB6  5e                       pop esi
FFE1BDB7  c3                       ret 
FFE1BDB8  55                       push ebp
FFE1BDB9  8bec                     mov ebp, esp
FFE1BDBB  83e4f8                   and esp, 0xfffffff8
FFE1BDBE  83ec10                   sub esp, 0x10
FFE1BDC1  8b06                     mov eax, dword ptr [esi]
FFE1BDC3  53                       push ebx
FFE1BDC4  57                       push edi
FFE1BDC5  8d4c2410                 lea ecx, [esp + 0x10]
FFE1BDC9  33db                     xor ebx, ebx
FFE1BDCB  51                       push ecx
FFE1BDCC  53                       push ebx
FFE1BDCD  56                       push esi
FFE1BDCE  895c2420                 mov dword ptr [esp + 0x20], ebx
FFE1BDD2  895c2418                 mov dword ptr [esp + 0x18], ebx
FFE1BDD6  ff5038                   call dword ptr [eax + 0x38]
FFE1BDD9  8b06                     mov eax, dword ptr [esi]
FFE1BDDB  83c40c                   add esp, 0xc
FFE1BDDE  8d4c2410                 lea ecx, [esp + 0x10]
FFE1BDE2  51                       push ecx
FFE1BDE3  53                       push ebx
FFE1BDE4  56                       push esi
FFE1BDE5  ff5038                   call dword ptr [eax + 0x38]
FFE1BDE8  83c40c                   add esp, 0xc
FFE1BDEB  3bc3                     cmp eax, ebx
FFE1BDED  7c64                     jl 0xffe1be53
FFE1BDEF  bf0e000080               mov edi, 0x8000000e
FFE1BDF4  895c240c                 mov dword ptr [esp + 0xc], ebx
FFE1BDF8  eb0d                     jmp 0xffe1be07
FFE1BDFA  8b44240c                 mov eax, dword ptr [esp + 0xc]
FFE1BDFE  e84e040000               call 0xffe1c251
FFE1BE03  84c0                     test al, al
FFE1BE05  7534                     jne 0xffe1be3b
FFE1BE07  8b06                     mov eax, dword ptr [esi]
FFE1BE09  8d4c240c                 lea ecx, [esp + 0xc]
FFE1BE0D  51                       push ecx
FFE1BE0E  ff742414                 push dword ptr [esp + 0x14]
FFE1BE12  6a02                     push 2
FFE1BE14  56                       push esi
FFE1BE15  ff503c                   call dword ptr [eax + 0x3c]
FFE1BE18  83c410                   add esp, 0x10
FFE1BE1B  3bc7                     cmp eax, edi
FFE1BE1D  75db                     jne 0xffe1bdfa
FFE1BE1F  ff442414                 inc dword ptr [esp + 0x14]
FFE1BE23  8b06                     mov eax, dword ptr [esi]
FFE1BE25  8d4c2410                 lea ecx, [esp + 0x10]
FFE1BE29  51                       push ecx
FFE1BE2A  ff742418                 push dword ptr [esp + 0x18]
FFE1BE2E  56                       push esi
FFE1BE2F  ff5038                   call dword ptr [eax + 0x38]
FFE1BE32  83c40c                   add esp, 0xc
FFE1BE35  3bc3                     cmp eax, ebx
FFE1BE37  7dbb                     jge 0xffe1bdf4
FFE1BE39  eb18                     jmp 0xffe1be53
FFE1BE3B  ff7508                   push dword ptr [ebp + 8]
FFE1BE3E  8b06                     mov eax, dword ptr [esi]
FFE1BE40  ff742410                 push dword ptr [esp + 0x10]
FFE1BE44  6a19                     push 0x19
FFE1BE46  56                       push esi
FFE1BE47  ff5040                   call dword ptr [eax + 0x40]
FFE1BE4A  83c410                   add esp, 0x10
FFE1BE4D  3bc3                     cmp eax, ebx
FFE1BE4F  7d02                     jge 0xffe1be53
FFE1BE51  8bc7                     mov eax, edi
FFE1BE53  5f                       pop edi
FFE1BE54  5b                       pop ebx
FFE1BE55  8be5                     mov esp, ebp
FFE1BE57  5d                       pop ebp
FFE1BE58  c3                       ret 
FFE1BE59  55                       push ebp
FFE1BE5A  8bec                     mov ebp, esp
FFE1BE5C  83ec60                   sub esp, 0x60
FFE1BE5F  53                       push ebx
FFE1BE60  b88d490000               mov eax, 0x498d
FFE1BE65  668945e4                 mov word ptr [ebp - 0x1c], ax
FFE1BE69  56                       push esi
FFE1BE6A  b89d420000               mov eax, 0x429d
FFE1BE6F  57                       push edi
FFE1BE70  c745e075b10ab6           mov dword ptr [ebp - 0x20], 0xb60ab175
FFE1BE77  668945e6                 mov word ptr [ebp - 0x1a], ax
FFE1BE7B  c645e8ad                 mov byte ptr [ebp - 0x18], 0xad
FFE1BE7F  c645e9ba                 mov byte ptr [ebp - 0x17], 0xba
FFE1BE83  c645ea0a                 mov byte ptr [ebp - 0x16], 0xa
FFE1BE87  c645eb62                 mov byte ptr [ebp - 0x15], 0x62
FFE1BE8B  c645ec2c                 mov byte ptr [ebp - 0x14], 0x2c
FFE1BE8F  c645ed58                 mov byte ptr [ebp - 0x13], 0x58
FFE1BE93  c645ee16                 mov byte ptr [ebp - 0x12], 0x16
FFE1BE97  c645efe2                 mov byte ptr [ebp - 0x11], 0xe2
FFE1BE9B  e842040000               call 0xffe1c2e2
FFE1BEA0  8b08                     mov ecx, dword ptr [eax]
FFE1BEA2  8d55f4                   lea edx, [ebp - 0xc]
FFE1BEA5  52                       push edx
FFE1BEA6  50                       push eax
FFE1BEA7  ff5128                   call dword ptr [ecx + 0x28]
FFE1BEAA  59                       pop ecx
FFE1BEAB  59                       pop ecx
FFE1BEAC  85c0                     test eax, eax
FFE1BEAE  0f8c4e010000             jl 0xffe1c002
FFE1BEB4  837df420                 cmp dword ptr [ebp - 0xc], 0x20
FFE1BEB8  0f8444010000             je 0xffe1c002
FFE1BEBE  837df412                 cmp dword ptr [ebp - 0xc], 0x12
FFE1BEC2  0f843a010000             je 0xffe1c002
FFE1BEC8  8b5d08                   mov ebx, dword ptr [ebp + 8]
FFE1BECB  8b03                     mov eax, dword ptr [ebx]
FFE1BECD  8d4df8                   lea ecx, [ebp - 8]
FFE1BED0  51                       push ecx
FFE1BED1  6a19                     push 0x19
FFE1BED3  6a04                     push 4
FFE1BED5  53                       push ebx
FFE1BED6  ff5034                   call dword ptr [eax + 0x34]
FFE1BED9  83c410                   add esp, 0x10
FFE1BEDC  85c0                     test eax, eax
FFE1BEDE  0f8c1e010000             jl 0xffe1c002
FFE1BEE4  8b7df8                   mov edi, dword ptr [ebp - 8]
FFE1BEE7  83c708                   add edi, 8
FFE1BEEA  8d75e0                   lea esi, [ebp - 0x20]
FFE1BEED  a5                       movsd dword ptr es:[edi], dword ptr [esi]
FFE1BEEE  a5                       movsd dword ptr es:[edi], dword ptr [esi]
FFE1BEEF  a5                       movsd dword ptr es:[edi], dword ptr [esi]
FFE1BEF0  a5                       movsd dword ptr es:[edi], dword ptr [esi]
FFE1BEF1  8b45f8                   mov eax, dword ptr [ebp - 8]
FFE1BEF4  c6401800                 mov byte ptr [eax + 0x18], 0
FFE1BEF8  b93a010000               mov ecx, 0x13a
FFE1BEFD  0f32                     rdmsr 
FFE1BEFF  2401                     and al, 1
FFE1BF01  fec8                     dec al
FFE1BF03  0fb6f0                   movzx esi, al
FFE1BF06  f7de                     neg esi
FFE1BF08  1bf6                     sbb esi, esi
FFE1BF0A  81e603000080             and esi, 0x80000003
FFE1BF10  837df411                 cmp dword ptr [ebp - 0xc], 0x11
FFE1BF14  8955ec                   mov dword ptr [ebp - 0x14], edx
FFE1BF17  0f84e3000000             je 0xffe1c000
FFE1BF1D  85f6                     test esi, esi
FFE1BF1F  0f8cdb000000             jl 0xffe1c000
FFE1BF25  e8e2040000               call 0xffe1c40c
FFE1BF2A  8b0b                     mov ecx, dword ptr [ebx]
FFE1BF2C  8d55fc                   lea edx, [ebp - 4]
FFE1BF2F  52                       push edx
FFE1BF30  50                       push eax
FFE1BF31  53                       push ebx
FFE1BF32  ff514c                   call dword ptr [ecx + 0x4c]
FFE1BF35  8bf0                     mov esi, eax
FFE1BF37  83c40c                   add esp, 0xc
FFE1BF3A  85f6                     test esi, esi
FFE1BF3C  0f8cc0000000             jl 0xffe1c002
FFE1BF42  e8e6020000               call 0xffe1c22d
FFE1BF47  8945f0                   mov dword ptr [ebp - 0x10], eax
FFE1BF4A  85c0                     test eax, eax
FFE1BF4C  0f84ae000000             je 0xffe1c000
FFE1BF52  8d45f0                   lea eax, [ebp - 0x10]
FFE1BF55  50                       push eax
FFE1BF56  8bf3                     mov esi, ebx
FFE1BF58  e85bfeffff               call 0xffe1bdb8
FFE1BF5D  8bf0                     mov esi, eax
FFE1BF5F  59                       pop ecx
FFE1BF60  85f6                     test esi, esi
FFE1BF62  0f8c9a000000             jl 0xffe1c002
FFE1BF68  ff75fc                   push dword ptr [ebp - 4]
FFE1BF6B  8b7df0                   mov edi, dword ptr [ebp - 0x10]
FFE1BF6E  e8a9040000               call 0xffe1c41c
FFE1BF73  ff7724                   push dword ptr [edi + 0x24]
FFE1BF76  ff7720                   push dword ptr [edi + 0x20]
FFE1BF79  ff75fc                   push dword ptr [ebp - 4]
FFE1BF7C  e8bb040000               call 0xffe1c43c
FFE1BF81  8d45c0                   lea eax, [ebp - 0x40]
FFE1BF84  50                       push eax
FFE1BF85  ff75fc                   push dword ptr [ebp - 4]
FFE1BF88  e8cf040000               call 0xffe1c45c
FFE1BF8D  8d45c0                   lea eax, [ebp - 0x40]
FFE1BF90  83c418                   add esp, 0x18
FFE1BF93  3bf8                     cmp edi, eax
FFE1BF95  7410                     je 0xffe1bfa7
FFE1BF97  6a20                     push 0x20
FFE1BF99  50                       push eax
FFE1BF9A  57                       push edi
FFE1BF9B  e86c030000               call 0xffe1c30c
FFE1BFA0  83c40c                   add esp, 0xc
FFE1BFA3  85c0                     test eax, eax
FFE1BFA5  7560                     jne 0xffe1c007
FFE1BFA7  8b45f8                   mov eax, dword ptr [ebp - 8]
FFE1BFAA  80481801                 or byte ptr [eax + 0x18], 1
FFE1BFAE  837f4800                 cmp dword ptr [edi + 0x48], 0
FFE1BFB2  744c                     je 0xffe1c000
FFE1BFB4  837f4c00                 cmp dword ptr [edi + 0x4c], 0
FFE1BFB8  7446                     je 0xffe1c000
FFE1BFBA  ff75fc                   push dword ptr [ebp - 4]
FFE1BFBD  e85a040000               call 0xffe1c41c
FFE1BFC2  ff774c                   push dword ptr [edi + 0x4c]
FFE1BFC5  ff7748                   push dword ptr [edi + 0x48]
FFE1BFC8  ff75fc                   push dword ptr [ebp - 4]
FFE1BFCB  e86c040000               call 0xffe1c43c
FFE1BFD0  8d45a0                   lea eax, [ebp - 0x60]
FFE1BFD3  50                       push eax
FFE1BFD4  ff75fc                   push dword ptr [ebp - 4]
FFE1BFD7  e880040000               call 0xffe1c45c
FFE1BFDC  83c728                   add edi, 0x28
FFE1BFDF  8d45a0                   lea eax, [ebp - 0x60]
FFE1BFE2  83c418                   add esp, 0x18
FFE1BFE5  3bf8                     cmp edi, eax
FFE1BFE7  7410                     je 0xffe1bff9
FFE1BFE9  6a20                     push 0x20
FFE1BFEB  50                       push eax
FFE1BFEC  57                       push edi
FFE1BFED  e81a030000               call 0xffe1c30c
FFE1BFF2  83c40c                   add esp, 0xc
FFE1BFF5  85c0                     test eax, eax
FFE1BFF7  750e                     jne 0xffe1c007
FFE1BFF9  8b45f8                   mov eax, dword ptr [ebp - 8]
FFE1BFFC  80481801                 or byte ptr [eax + 0x18], 1
FFE1C000  8bc6                     mov eax, esi
FFE1C002  5f                       pop edi
FFE1C003  5e                       pop esi
FFE1C004  5b                       pop ebx
FFE1C005  c9                       leave 
FFE1C006  c3                       ret 
FFE1C007  8b45f8                   mov eax, dword ptr [ebp - 8]
FFE1C00A  80601810                 and byte ptr [eax + 0x18], 0x10
FFE1C00E  e8cf020000               call 0xffe1c2e2
FFE1C013  8b08                     mov ecx, dword ptr [eax]
FFE1C015  6a20                     push 0x20
FFE1C017  50                       push eax
FFE1C018  ff512c                   call dword ptr [ecx + 0x2c]
FFE1C01B  59                       pop ecx
FFE1C01C  59                       pop ecx
FFE1C01D  e81c020000               call 0xffe1c23e
FFE1C022  33c0                     xor eax, eax
FFE1C024  ebdc                     jmp 0xffe1c002
FFE1C026  55                       push ebp
FFE1C027  8bec                     mov ebp, esp
FFE1C029  51                       push ecx
FFE1C02A  e87e020000               call 0xffe1c2ad
FFE1C02F  a802                     test al, 2
FFE1C031  7562                     jne 0xffe1c095
FFE1C033  b800a00ff8               mov eax, 0xf80fa000
FFE1C038  668b00                   mov ax, word ptr [eax]
FFE1C03B  0fb7c0                   movzx eax, ax
FFE1C03E  b9ffff0000               mov ecx, 0xffff
FFE1C043  663bc1                   cmp ax, cx
FFE1C046  7413                     je 0xffe1c05b
FFE1C048  b840a00ff8               mov eax, 0xf80fa040
FFE1C04D  668b00                   mov ax, word ptr [eax]
FFE1C050  0fb7c0                   movzx eax, ax
FFE1C053  25fcff0000               and eax, 0xfffc
FFE1C058  8945fc                   mov dword ptr [ebp - 4], eax
FFE1C05B  0fb74dfc                 movzx ecx, word ptr [ebp - 4]
FFE1C05F  668bd1                   mov dx, cx
FFE1C062  66ed                     in ax, dx
FFE1C064  0fb7c0                   movzx eax, ax
FFE1C067  a900080000               test eax, 0x800
FFE1C06C  7527                     jne 0xffe1c095
FFE1C06E  66ed                     in ax, dx
FFE1C070  0fb7c0                   movzx eax, ax
FFE1C073  a900800000               test eax, 0x8000
FFE1C078  741b                     je 0xffe1c095
FFE1C07A  8d5104                   lea edx, [ecx + 4]
FFE1C07D  66ed                     in ax, dx
FFE1C07F  0fb7c0                   movzx eax, ax
FFE1C082  25001c0000               and eax, 0x1c00
FFE1C087  b900140000               mov ecx, 0x1400
FFE1C08C  663bc1                   cmp ax, cx
FFE1C08F  7504                     jne 0xffe1c095
FFE1C091  b001                     mov al, 1
FFE1C093  c9                       leave 
FFE1C094  c3                       ret 
FFE1C095  32c0                     xor al, al
FFE1C097  c9                       leave 
FFE1C098  c3                       ret 
FFE1C099  55                       push ebp
FFE1C09A  8bec                     mov ebp, esp
FFE1C09C  83ec10                   sub esp, 0x10
FFE1C09F  53                       push ebx
FFE1C0A0  89356cd7e1ff             mov dword ptr [0xffe1d76c], esi
FFE1C0A6  b93a010000               mov ecx, 0x13a
FFE1C0AB  0f32                     rdmsr 
FFE1C0AD  33db                     xor ebx, ebx
FFE1C0AF  43                       inc ebx
FFE1C0B0  23d3                     and edx, ebx
FFE1C0B2  33c0                     xor eax, eax
FFE1C0B4  0bc2                     or eax, edx
FFE1C0B6  7507                     jne 0xffe1c0bf
FFE1C0B8  33c0                     xor eax, eax
FFE1C0BA  e9e4000000               jmp 0xffe1c1a3
FFE1C0BF  b93a010000               mov ecx, 0x13a
FFE1C0C4  0f32                     rdmsr 
FFE1C0C6  8955f4                   mov dword ptr [ebp - 0xc], edx
FFE1C0C9  85c0                     test eax, eax
FFE1C0CB  74eb                     je 0xffe1c0b8
FFE1C0CD  57                       push edi
FFE1C0CE  e853ffffff               call 0xffe1c026
FFE1C0D3  6a11                     push 0x11
FFE1C0D5  5f                       pop edi
FFE1C0D6  84c0                     test al, al
FFE1C0D8  740c                     je 0xffe1c0e6
FFE1C0DA  8b06                     mov eax, dword ptr [esi]
FFE1C0DC  57                       push edi
FFE1C0DD  56                       push esi
FFE1C0DE  897dfc                   mov dword ptr [ebp - 4], edi
FFE1C0E1  ff502c                   call dword ptr [eax + 0x2c]
FFE1C0E4  59                       pop ecx
FFE1C0E5  59                       pop ecx
FFE1C0E6  e8f7010000               call 0xffe1c2e2
FFE1C0EB  8b08                     mov ecx, dword ptr [eax]
FFE1C0ED  8d55fc                   lea edx, [ebp - 4]
FFE1C0F0  52                       push edx
FFE1C0F1  50                       push eax
FFE1C0F2  ff5128                   call dword ptr [ecx + 0x28]
FFE1C0F5  59                       pop ecx
FFE1C0F6  59                       pop ecx
FFE1C0F7  85c0                     test eax, eax
FFE1C0F9  0f8ca3000000             jl 0xffe1c1a2
FFE1C0FF  397dfc                   cmp dword ptr [ebp - 4], edi
FFE1C102  7542                     jne 0xffe1c146
FFE1C104  b93a010000               mov ecx, 0x13a
FFE1C109  0f32                     rdmsr 
FFE1C10B  8955f4                   mov dword ptr [ebp - 0xc], edx
FFE1C10E  a820                     test al, 0x20
FFE1C110  7408                     je 0xffe1c11a
FFE1C112  a808                     test al, 8
FFE1C114  7404                     je 0xffe1c11a
FFE1C116  33ff                     xor edi, edi
FFE1C118  eb05                     jmp 0xffe1c11f
FFE1C11A  bf03000080               mov edi, 0x80000003
FFE1C11F  b93a010000               mov ecx, 0x13a
FFE1C124  0f32                     rdmsr 
FFE1C126  83e006                   and eax, 6
FFE1C129  8955f4                   mov dword ptr [ebp - 0xc], edx
FFE1C12C  3c06                     cmp al, 6
FFE1C12E  7531                     jne 0xffe1c161
FFE1C130  6a32                     push 0x32
FFE1C132  891d0800d4fe             mov dword ptr [0xfed40008], ebx
FFE1C138  e869000000               call 0xffe1c1a6
FFE1C13D  59                       pop ecx
FFE1C13E  891d4000d4fe             mov dword ptr [0xfed40040], ebx
FFE1C144  eb1b                     jmp 0xffe1c161
FFE1C146  b93a010000               mov ecx, 0x13a
FFE1C14B  0f32                     rdmsr 
FFE1C14D  8955f4                   mov dword ptr [ebp - 0xc], edx
FFE1C150  84c3                     test bl, al
FFE1C152  7408                     je 0xffe1c15c
FFE1C154  a820                     test al, 0x20
FFE1C156  7404                     je 0xffe1c15c
FFE1C158  a808                     test al, 8
FFE1C15A  7509                     jne 0xffe1c165
FFE1C15C  bf03000080               mov edi, 0x80000003
FFE1C161  85ff                     test edi, edi
FFE1C163  7c2b                     jl 0xffe1c190
FFE1C165  8b06                     mov eax, dword ptr [esi]
FFE1C167  8d4df8                   lea ecx, [ebp - 8]
FFE1C16A  51                       push ecx
FFE1C16B  6a00                     push 0
FFE1C16D  6a00                     push 0
FFE1C16F  689cd3e1ff               push 0xffe1d39c
FFE1C174  56                       push esi
FFE1C175  ff5020                   call dword ptr [eax + 0x20]
FFE1C178  83c414                   add esp, 0x14
FFE1C17B  85c0                     test eax, eax
FFE1C17D  7d11                     jge 0xffe1c190
FFE1C17F  8b06                     mov eax, dword ptr [esi]
FFE1C181  68acd3e1ff               push 0xffe1d3ac
FFE1C186  56                       push esi
FFE1C187  ff5018                   call dword ptr [eax + 0x18]
FFE1C18A  59                       pop ecx
FFE1C18B  59                       pop ecx
FFE1C18C  85c0                     test eax, eax
FFE1C18E  7c12                     jl 0xffe1c1a2
FFE1C190  e84d010000               call 0xffe1c2e2
FFE1C195  8b08                     mov ecx, dword ptr [eax]
FFE1C197  6890d3e1ff               push 0xffe1d390
FFE1C19C  50                       push eax
FFE1C19D  ff5124                   call dword ptr [ecx + 0x24]
FFE1C1A0  59                       pop ecx
FFE1C1A1  59                       pop ecx
FFE1C1A2  5f                       pop edi
FFE1C1A3  5b                       pop ebx
FFE1C1A4  c9                       leave 
FFE1C1A5  c3                       ret 
FFE1C1A6  55                       push ebp
FFE1C1A7  8bec                     mov ebp, esp
FFE1C1A9  51                       push ecx
FFE1C1AA  51                       push ecx
FFE1C1AB  56                       push esi
FFE1C1AC  57                       push edi
FFE1C1AD  ba08180000               mov edx, 0x1808
FFE1C1B2  ed                       in eax, dx
FFE1C1B3  b9ffffff00               mov ecx, 0xffffff
FFE1C1B8  23c1                     and eax, ecx
FFE1C1BA  8bf8                     mov edi, eax
FFE1C1BC  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C1BF  69c066010000             imul eax, eax, 0x166
FFE1C1C5  6a64                     push 0x64
FFE1C1C7  33d2                     xor edx, edx
FFE1C1C9  5e                       pop esi
FFE1C1CA  f7f6                     div esi
FFE1C1CC  897dfc                   mov dword ptr [ebp - 4], edi
FFE1C1CF  8d443801                 lea eax, [eax + edi + 1]
FFE1C1D3  8bf0                     mov esi, eax
FFE1C1D5  c1ee18                   shr esi, 0x18
FFE1C1D8  23c1                     and eax, ecx
FFE1C1DA  8945f8                   mov dword ptr [ebp - 8], eax
FFE1C1DD  85f6                     test esi, esi
FFE1C1DF  7508                     jne 0xffe1c1e9
FFE1C1E1  8b45f8                   mov eax, dword ptr [ebp - 8]
FFE1C1E4  3b45fc                   cmp eax, dword ptr [ebp - 4]
FFE1C1E7  7618                     jbe 0xffe1c201
FFE1C1E9  ba08180000               mov edx, 0x1808
FFE1C1EE  ed                       in eax, dx
FFE1C1EF  23c1                     and eax, ecx
FFE1C1F1  8945fc                   mov dword ptr [ebp - 4], eax
FFE1C1F4  3bc7                     cmp eax, edi
FFE1C1F6  7305                     jae 0xffe1c1fd
FFE1C1F8  85f6                     test esi, esi
FFE1C1FA  7405                     je 0xffe1c201
FFE1C1FC  4e                       dec esi
FFE1C1FD  8bf8                     mov edi, eax
FFE1C1FF  ebdc                     jmp 0xffe1c1dd
FFE1C201  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C204  5f                       pop edi
FFE1C205  5e                       pop esi
FFE1C206  c9                       leave 
FFE1C207  c3                       ret 
FFE1C208  55                       push ebp
FFE1C209  8bec                     mov ebp, esp
FFE1C20B  51                       push ecx
FFE1C20C  e8d1000000               call 0xffe1c2e2
FFE1C211  8b08                     mov ecx, dword ptr [eax]
FFE1C213  8d55fc                   lea edx, [ebp - 4]
FFE1C216  52                       push edx
FFE1C217  6a50                     push 0x50
FFE1C219  50                       push eax
FFE1C21A  ff514c                   call dword ptr [ecx + 0x4c]
FFE1C21D  83c40c                   add esp, 0xc
FFE1C220  85c0                     test eax, eax
FFE1C222  7d04                     jge 0xffe1c228
FFE1C224  8365fc00                 and dword ptr [ebp - 4], 0
FFE1C228  8b45fc                   mov eax, dword ptr [ebp - 4]
FFE1C22B  c9                       leave 
FFE1C22C  c3                       ret 
FFE1C22D  e8d6ffffff               call 0xffe1c208
FFE1C232  85c0                     test eax, eax
FFE1C234  7407                     je 0xffe1c23d
FFE1C236  50                       push eax
FFE1C237  e846000000               call 0xffe1c282
FFE1C23C  59                       pop ecx
FFE1C23D  c3                       ret 
FFE1C23E  e89f000000               call 0xffe1c2e2
FFE1C243  8b08                     mov ecx, dword ptr [eax]
FFE1C245  6874d3e1ff               push 0xffe1d374
FFE1C24A  50                       push eax
FFE1C24B  ff5118                   call dword ptr [ecx + 0x18]
FFE1C24E  59                       pop ecx
FFE1C24F  59                       pop ecx
FFE1C250  c3                       ret 
FFE1C251  8b08                     mov ecx, dword ptr [eax]
FFE1C253  3b0d80d3e1ff             cmp ecx, dword ptr [0xffe1d380]
FFE1C259  7524                     jne 0xffe1c27f
FFE1C25B  8b4804                   mov ecx, dword ptr [eax + 4]
FFE1C25E  3b0d84d3e1ff             cmp ecx, dword ptr [0xffe1d384]
FFE1C264  7519                     jne 0xffe1c27f
FFE1C266  8b4808                   mov ecx, dword ptr [eax + 8]
FFE1C269  3b0d88d3e1ff             cmp ecx, dword ptr [0xffe1d388]
FFE1C26F  750e                     jne 0xffe1c27f
FFE1C271  8b400c                   mov eax, dword ptr [eax + 0xc]
FFE1C274  3b058cd3e1ff             cmp eax, dword ptr [0xffe1d38c]
FFE1C27A  7503                     jne 0xffe1c27f
FFE1C27C  b001                     mov al, 1
FFE1C27E  c3                       ret 
FFE1C27F  32c0                     xor al, al
FFE1C281  c3                       ret 
FFE1C282  6a50                     push 0x50
FFE1C284  ff742408                 push dword ptr [esp + 8]
FFE1C288  e8db000000               call 0xffe1c368
FFE1C28D  59                       pop ecx
FFE1C28E  59                       pop ecx
FFE1C28F  c3                       ret 
FFE1C290  55                       push ebp
FFE1C291  8bec                     mov ebp, esp
FFE1C293  8b4d10                   mov ecx, dword ptr [ebp + 0x10]
FFE1C296  8b450c                   mov eax, dword ptr [ebp + 0xc]
FFE1C299  33d2                     xor edx, edx
FFE1C29B  f7f1                     div ecx
FFE1C29D  50                       push eax
FFE1C29E  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C2A1  f7f1                     div ecx
FFE1C2A3  8b4d14                   mov ecx, dword ptr [ebp + 0x14]
FFE1C2A6  e302                     jecxz 0xffe1c2aa
FFE1C2A8  8911                     mov dword ptr [ecx], edx
FFE1C2AA  5a                       pop edx
FFE1C2AB  5d                       pop ebp
FFE1C2AC  c3                       ret 
FFE1C2AD  53                       push ebx
FFE1C2AE  56                       push esi
FFE1C2AF  57                       push edi
FFE1C2B0  9c                       pushfd 
FFE1C2B1  58                       pop eax
FFE1C2B2  8bf0                     mov esi, eax
FFE1C2B4  fa                       cli 
FFE1C2B5  b9f80c0000               mov ecx, 0xcf8
FFE1C2BA  8bd1                     mov edx, ecx
FFE1C2BC  ed                       in eax, dx
FFE1C2BD  8bf8                     mov edi, eax
FFE1C2BF  b8a4fa0080               mov eax, 0x8000faa4
FFE1C2C4  ef                       out dx, eax
FFE1C2C5  83c204                   add edx, 4
FFE1C2C8  ec                       in al, dx
FFE1C2C9  8ad8                     mov bl, al
FFE1C2CB  8bd1                     mov edx, ecx
FFE1C2CD  8bc7                     mov eax, edi
FFE1C2CF  ef                       out dx, eax
FFE1C2D0  f7c600020000             test esi, 0x200
FFE1C2D6  7403                     je 0xffe1c2db
FFE1C2D8  fb                       sti 
FFE1C2D9  eb01                     jmp 0xffe1c2dc
FFE1C2DB  fa                       cli 
FFE1C2DC  5f                       pop edi
FFE1C2DD  5e                       pop esi
FFE1C2DE  8ac3                     mov al, bl
FFE1C2E0  5b                       pop ebx
FFE1C2E1  c3                       ret 
FFE1C2E2  55                       push ebp
FFE1C2E3  8bec                     mov ebp, esp
FFE1C2E5  83ec0c                   sub esp, 0xc
FFE1C2E8  8d45f4                   lea eax, [ebp - 0xc]
FFE1C2EB  8945fc                   mov dword ptr [ebp - 4], eax
FFE1C2EE  8b45fc                   mov eax, dword ptr [ebp - 4]
FFE1C2F1  0f0108                   sidt [eax]
FFE1C2F4  8b45f6                   mov eax, dword ptr [ebp - 0xa]
FFE1C2F7  8b40fc                   mov eax, dword ptr [eax - 4]
FFE1C2FA  c9                       leave 
FFE1C2FB  c3                       ret 
FFE1C2FC  e99b090000               jmp 0xffe1cc9c
FFE1C301  cc                       int3 
FFE1C302  cc                       int3 
FFE1C303  cc                       int3 
FFE1C304  cc                       int3 
FFE1C305  cc                       int3 
FFE1C306  cc                       int3 
FFE1C307  cc                       int3 
FFE1C308  cc                       int3 
FFE1C309  cc                       int3 
FFE1C30A  cc                       int3 
FFE1C30B  cc                       int3 
FFE1C30C  56                       push esi
FFE1C30D  57                       push edi
FFE1C30E  8b74240c                 mov esi, dword ptr [esp + 0xc]
FFE1C312  8b7c2410                 mov edi, dword ptr [esp + 0x10]
FFE1C316  8b4c2414                 mov ecx, dword ptr [esp + 0x14]
FFE1C31A  f3a6                     repe cmpsb byte ptr [esi], byte ptr es:[edi]
FFE1C31C  0fb646ff                 movzx eax, byte ptr [esi - 1]
FFE1C320  0fb657ff                 movzx edx, byte ptr [edi - 1]
FFE1C324  2bc2                     sub eax, edx
FFE1C326  5f                       pop edi
FFE1C327  5e                       pop esi
FFE1C328  c3                       ret 
FFE1C329  cc                       int3 
FFE1C32A  cc                       int3 
FFE1C32B  cc                       int3 
FFE1C32C  56                       push esi
FFE1C32D  57                       push edi
FFE1C32E  8b742410                 mov esi, dword ptr [esp + 0x10]
FFE1C332  8b7c240c                 mov edi, dword ptr [esp + 0xc]
FFE1C336  8b542414                 mov edx, dword ptr [esp + 0x14]
FFE1C33A  8d4432ff                 lea eax, [edx + esi - 1]
FFE1C33E  3bf7                     cmp esi, edi
FFE1C340  7304                     jae 0xffe1c346
FFE1C342  3bc7                     cmp eax, edi
FFE1C344  730c                     jae 0xffe1c352
FFE1C346  8bca                     mov ecx, edx
FFE1C348  83e203                   and edx, 3
FFE1C34B  c1e902                   shr ecx, 2
FFE1C34E  f3a5                     rep movsd dword ptr es:[edi], dword ptr [esi]
FFE1C350  eb07                     jmp 0xffe1c359
FFE1C352  8bf0                     mov esi, eax
FFE1C354  8d7c3aff                 lea edi, [edx + edi - 1]
FFE1C358  fd                       std 
FFE1C359  8bca                     mov ecx, edx
FFE1C35B  f3a4                     rep movsb byte ptr es:[edi], byte ptr [esi]
FFE1C35D  fc                       cld 
FFE1C35E  8b44240c                 mov eax, dword ptr [esp + 0xc]
FFE1C362  5f                       pop edi
FFE1C363  5e                       pop esi
FFE1C364  c3                       ret 
FFE1C365  cc                       int3 
FFE1C366  cc                       int3 
FFE1C367  cc                       int3 
FFE1C368  57                       push edi
FFE1C369  33c0                     xor eax, eax
FFE1C36B  8b7c2408                 mov edi, dword ptr [esp + 8]
FFE1C36F  8b4c240c                 mov ecx, dword ptr [esp + 0xc]
FFE1C373  8bd1                     mov edx, ecx
FFE1C375  c1e902                   shr ecx, 2
FFE1C378  83e203                   and edx, 3
FFE1C37B  57                       push edi
FFE1C37C  f3ab                     rep stosd dword ptr es:[edi], eax
FFE1C37E  8bca                     mov ecx, edx
FFE1C380  f3aa                     rep stosb byte ptr es:[edi], al
FFE1C382  58                       pop eax
FFE1C383  5f                       pop edi
FFE1C384  c3                       ret 
FFE1C385  cc                       int3 
FFE1C386  cc                       int3 
FFE1C387  cc                       int3 
FFE1C388  8b4c2410                 mov ecx, dword ptr [esp + 0x10]
FFE1C38C  85c9                     test ecx, ecx
FFE1C38E  7513                     jne 0xffe1c3a3
FFE1C390  8b4c2414                 mov ecx, dword ptr [esp + 0x14]
FFE1C394  e308                     jecxz 0xffe1c39e
FFE1C396  83610400                 and dword ptr [ecx + 4], 0
FFE1C39A  894c2410                 mov dword ptr [esp + 0x10], ecx
FFE1C39E  e9edfeffff               jmp 0xffe1c290
FFE1C3A3  53                       push ebx
FFE1C3A4  56                       push esi
FFE1C3A5  57                       push edi
FFE1C3A6  8b542414                 mov edx, dword ptr [esp + 0x14]
FFE1C3AA  8b442410                 mov eax, dword ptr [esp + 0x10]
FFE1C3AE  8bfa                     mov edi, edx
FFE1C3B0  8bf0                     mov esi, eax
FFE1C3B2  8b5c2418                 mov ebx, dword ptr [esp + 0x18]
FFE1C3B6  d1ea                     shr edx, 1
FFE1C3B8  d1d8                     rcr eax, 1
FFE1C3BA  0faccb01                 shrd ebx, ecx, 1
FFE1C3BE  d1e9                     shr ecx, 1
FFE1C3C0  75f4                     jne 0xffe1c3b6
FFE1C3C2  f7f3                     div ebx
FFE1C3C4  8bd8                     mov ebx, eax
FFE1C3C6  8b4c241c                 mov ecx, dword ptr [esp + 0x1c]
FFE1C3CA  f7642418                 mul dword ptr [esp + 0x18]
FFE1C3CE  0fafcb                   imul ecx, ebx
FFE1C3D1  03d1                     add edx, ecx
FFE1C3D3  8b4c2420                 mov ecx, dword ptr [esp + 0x20]
FFE1C3D7  720a                     jb 0xffe1c3e3
FFE1C3D9  3bfa                     cmp edi, edx
FFE1C3DB  7711                     ja 0xffe1c3ee
FFE1C3DD  7204                     jb 0xffe1c3e3
FFE1C3DF  3bf0                     cmp esi, eax
FFE1C3E1  730b                     jae 0xffe1c3ee
FFE1C3E3  4b                       dec ebx
FFE1C3E4  e313                     jecxz 0xffe1c3f9
FFE1C3E6  2b442418                 sub eax, dword ptr [esp + 0x18]
FFE1C3EA  1b54241c                 sbb edx, dword ptr [esp + 0x1c]
FFE1C3EE  e309                     jecxz 0xffe1c3f9
FFE1C3F0  2bf0                     sub esi, eax
FFE1C3F2  1bfa                     sbb edi, edx
FFE1C3F4  8931                     mov dword ptr [ecx], esi
FFE1C3F6  897904                   mov dword ptr [ecx + 4], edi
FFE1C3F9  8bc3                     mov eax, ebx
FFE1C3FB  33d2                     xor edx, edx
FFE1C3FD  5f                       pop edi
FFE1C3FE  5e                       pop esi
FFE1C3FF  5b                       pop ebx
FFE1C400  c3                       ret 
FFE1C401  cc                       int3 
FFE1C402  cc                       int3 
FFE1C403  cc                       int3 
FFE1C404  cc                       int3 
FFE1C405  cc                       int3 
FFE1C406  cc                       int3 
FFE1C407  cc                       int3 
FFE1C408  cc                       int3 
FFE1C409  cc                       int3 
FFE1C40A  cc                       int3 
FFE1C40B  cc                       int3 
FFE1C40C  55                       push ebp
FFE1C40D  8bec                     mov ebp, esp
FFE1C40F  b870000000               mov eax, 0x70
FFE1C414  5d                       pop ebp
FFE1C415  c3                       ret 
FFE1C416  cc                       int3 
FFE1C417  cc                       int3 
FFE1C418  cc                       int3 
FFE1C419  cc                       int3 
FFE1C41A  cc                       int3 
FFE1C41B  cc                       int3 
FFE1C41C  55                       push ebp
FFE1C41D  8bec                     mov ebp, esp
FFE1C41F  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C422  50                       push eax
FFE1C423  e854000000               call 0xffe1c47c
FFE1C428  83c404                   add esp, 4
FFE1C42B  b001                     mov al, 1
FFE1C42D  5d                       pop ebp
FFE1C42E  c3                       ret 
FFE1C42F  cc                       int3 
FFE1C430  cc                       int3 
FFE1C431  cc                       int3 
FFE1C432  cc                       int3 
FFE1C433  cc                       int3 
FFE1C434  cc                       int3 
FFE1C435  cc                       int3 
FFE1C436  cc                       int3 
FFE1C437  cc                       int3 
FFE1C438  cc                       int3 
FFE1C439  cc                       int3 
FFE1C43A  cc                       int3 
FFE1C43B  cc                       int3 
FFE1C43C  55                       push ebp
FFE1C43D  8bec                     mov ebp, esp
FFE1C43F  8b4510                   mov eax, dword ptr [ebp + 0x10]
FFE1C442  50                       push eax
FFE1C443  8b4d0c                   mov ecx, dword ptr [ebp + 0xc]
FFE1C446  51                       push ecx
FFE1C447  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1C44A  52                       push edx
FFE1C44B  e89c000000               call 0xffe1c4ec
FFE1C450  83c40c                   add esp, 0xc
FFE1C453  f7d8                     neg eax
FFE1C455  1bc0                     sbb eax, eax
FFE1C457  83c001                   add eax, 1
FFE1C45A  5d                       pop ebp
FFE1C45B  c3                       ret 
FFE1C45C  55                       push ebp
FFE1C45D  8bec                     mov ebp, esp
FFE1C45F  8b450c                   mov eax, dword ptr [ebp + 0xc]
FFE1C462  50                       push eax
FFE1C463  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C466  51                       push ecx
FFE1C467  e890050000               call 0xffe1c9fc
FFE1C46C  83c408                   add esp, 8
FFE1C46F  f7d8                     neg eax
FFE1C471  1bc0                     sbb eax, eax
FFE1C473  83c001                   add eax, 1
FFE1C476  5d                       pop ebp
FFE1C477  c3                       ret 
FFE1C478  cc                       int3 
FFE1C479  cc                       int3 
FFE1C47A  cc                       int3 
FFE1C47B  cc                       int3 
FFE1C47C  55                       push ebp
FFE1C47D  8bec                     mov ebp, esp
FFE1C47F  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C482  c7402800000000           mov dword ptr [eax + 0x28], 0
FFE1C489  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C48C  c70100000000             mov dword ptr [ecx], 0
FFE1C492  c7410400000000           mov dword ptr [ecx + 4], 0
FFE1C499  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1C49C  c7420867e6096a           mov dword ptr [edx + 8], 0x6a09e667
FFE1C4A3  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C4A6  c7400c85ae67bb           mov dword ptr [eax + 0xc], 0xbb67ae85
FFE1C4AD  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C4B0  c7411072f36e3c           mov dword ptr [ecx + 0x10], 0x3c6ef372
FFE1C4B7  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1C4BA  c742143af54fa5           mov dword ptr [edx + 0x14], 0xa54ff53a
FFE1C4C1  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C4C4  c740187f520e51           mov dword ptr [eax + 0x18], 0x510e527f
FFE1C4CB  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C4CE  c7411c8c68059b           mov dword ptr [ecx + 0x1c], 0x9b05688c
FFE1C4D5  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1C4D8  c74220abd9831f           mov dword ptr [edx + 0x20], 0x1f83d9ab
FFE1C4DF  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C4E2  c7402419cde05b           mov dword ptr [eax + 0x24], 0x5be0cd19
FFE1C4E9  5d                       pop ebp
FFE1C4EA  c3                       ret 
FFE1C4EB  cc                       int3 
FFE1C4EC  55                       push ebp
FFE1C4ED  8bec                     mov ebp, esp
FFE1C4EF  83ec08                   sub esp, 8
FFE1C4F2  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C4F5  83782840                 cmp dword ptr [eax + 0x28], 0x40
FFE1C4F9  7608                     jbe 0xffe1c503
FFE1C4FB  83c8ff                   or eax, 0xffffffff
FFE1C4FE  e91f010000               jmp 0xffe1c622
FFE1C503  837d1000                 cmp dword ptr [ebp + 0x10], 0
FFE1C507  0f8613010000             jbe 0xffe1c620
FFE1C50D  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C510  83792800                 cmp dword ptr [ecx + 0x28], 0
FFE1C514  7552                     jne 0xffe1c568
FFE1C516  837d1040                 cmp dword ptr [ebp + 0x10], 0x40
FFE1C51A  724c                     jb 0xffe1c568
FFE1C51C  8b550c                   mov edx, dword ptr [ebp + 0xc]
FFE1C51F  52                       push edx
FFE1C520  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C523  50                       push eax
FFE1C524  e803010000               call 0xffe1c62c
FFE1C529  83c408                   add esp, 8
FFE1C52C  85c0                     test eax, eax
FFE1C52E  7d08                     jge 0xffe1c538
FFE1C530  83c8ff                   or eax, 0xffffffff
FFE1C533  e9ea000000               jmp 0xffe1c622
FFE1C538  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C53B  8b11                     mov edx, dword ptr [ecx]
FFE1C53D  81c200020000             add edx, 0x200
FFE1C543  8b4104                   mov eax, dword ptr [ecx + 4]
FFE1C546  83d000                   adc eax, 0
FFE1C549  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C54C  8911                     mov dword ptr [ecx], edx
FFE1C54E  894104                   mov dword ptr [ecx + 4], eax
FFE1C551  8b550c                   mov edx, dword ptr [ebp + 0xc]
FFE1C554  83c240                   add edx, 0x40
FFE1C557  89550c                   mov dword ptr [ebp + 0xc], edx
FFE1C55A  8b4510                   mov eax, dword ptr [ebp + 0x10]
FFE1C55D  83e840                   sub eax, 0x40
FFE1C560  894510                   mov dword ptr [ebp + 0x10], eax
FFE1C563  e9b3000000               jmp 0xffe1c61b
FFE1C568  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C56B  ba40000000               mov edx, 0x40
FFE1C570  2b5128                   sub edx, dword ptr [ecx + 0x28]
FFE1C573  395510                   cmp dword ptr [ebp + 0x10], edx
FFE1C576  7308                     jae 0xffe1c580
FFE1C578  8b4510                   mov eax, dword ptr [ebp + 0x10]
FFE1C57B  8945f8                   mov dword ptr [ebp - 8], eax
FFE1C57E  eb0e                     jmp 0xffe1c58e
FFE1C580  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C583  ba40000000               mov edx, 0x40
FFE1C588  2b5128                   sub edx, dword ptr [ecx + 0x28]
FFE1C58B  8955f8                   mov dword ptr [ebp - 8], edx
FFE1C58E  8b45f8                   mov eax, dword ptr [ebp - 8]
FFE1C591  8945fc                   mov dword ptr [ebp - 4], eax
FFE1C594  8b4dfc                   mov ecx, dword ptr [ebp - 4]
FFE1C597  51                       push ecx
FFE1C598  8b550c                   mov edx, dword ptr [ebp + 0xc]
FFE1C59B  52                       push edx
FFE1C59C  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C59F  8b4828                   mov ecx, dword ptr [eax + 0x28]
FFE1C5A2  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1C5A5  8d440a2c                 lea eax, [edx + ecx + 0x2c]
FFE1C5A9  50                       push eax
FFE1C5AA  e84dfdffff               call 0xffe1c2fc
FFE1C5AF  83c40c                   add esp, 0xc
FFE1C5B2  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C5B5  8b5128                   mov edx, dword ptr [ecx + 0x28]
FFE1C5B8  0355fc                   add edx, dword ptr [ebp - 4]
FFE1C5BB  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C5BE  895028                   mov dword ptr [eax + 0x28], edx
FFE1C5C1  8b4d0c                   mov ecx, dword ptr [ebp + 0xc]
FFE1C5C4  034dfc                   add ecx, dword ptr [ebp - 4]
FFE1C5C7  894d0c                   mov dword ptr [ebp + 0xc], ecx
FFE1C5CA  8b5510                   mov edx, dword ptr [ebp + 0x10]
FFE1C5CD  2b55fc                   sub edx, dword ptr [ebp - 4]
FFE1C5D0  895510                   mov dword ptr [ebp + 0x10], edx
FFE1C5D3  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C5D6  83782840                 cmp dword ptr [eax + 0x28], 0x40
FFE1C5DA  753f                     jne 0xffe1c61b
FFE1C5DC  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C5DF  83c12c                   add ecx, 0x2c
FFE1C5E2  51                       push ecx
FFE1C5E3  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1C5E6  52                       push edx
FFE1C5E7  e840000000               call 0xffe1c62c
FFE1C5EC  83c408                   add esp, 8
FFE1C5EF  85c0                     test eax, eax
FFE1C5F1  7d05                     jge 0xffe1c5f8
FFE1C5F3  83c8ff                   or eax, 0xffffffff
FFE1C5F6  eb2a                     jmp 0xffe1c622
FFE1C5F8  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C5FB  8b08                     mov ecx, dword ptr [eax]
FFE1C5FD  81c100020000             add ecx, 0x200
FFE1C603  8b5004                   mov edx, dword ptr [eax + 4]
FFE1C606  83d200                   adc edx, 0
FFE1C609  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C60C  8908                     mov dword ptr [eax], ecx
FFE1C60E  895004                   mov dword ptr [eax + 4], edx
FFE1C611  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C614  c7412800000000           mov dword ptr [ecx + 0x28], 0
FFE1C61B  e9e3feffff               jmp 0xffe1c503
FFE1C620  33c0                     xor eax, eax
FFE1C622  8be5                     mov esp, ebp
FFE1C624  5d                       pop ebp
FFE1C625  c3                       ret 
FFE1C626  cc                       int3 
FFE1C627  cc                       int3 
FFE1C628  cc                       int3 
FFE1C629  cc                       int3 
FFE1C62A  cc                       int3 
FFE1C62B  cc                       int3 
FFE1C62C  55                       push ebp
FFE1C62D  8bec                     mov ebp, esp
FFE1C62F  81ec30010000             sub esp, 0x130
FFE1C635  56                       push esi
FFE1C636  c785fcfeffff00000000     mov dword ptr [ebp - 0x104], 0
FFE1C640  eb0f                     jmp 0xffe1c651
FFE1C642  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C648  83c001                   add eax, 1
FFE1C64B  8985fcfeffff             mov dword ptr [ebp - 0x104], eax
FFE1C651  83bdfcfeffff08           cmp dword ptr [ebp - 0x104], 8
FFE1C658  7d1c                     jge 0xffe1c676
FFE1C65A  8b8dfcfeffff             mov ecx, dword ptr [ebp - 0x104]
FFE1C660  8b95fcfeffff             mov edx, dword ptr [ebp - 0x104]
FFE1C666  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1C669  8b549008                 mov edx, dword ptr [eax + edx*4 + 8]
FFE1C66D  89948ddcfeffff           mov dword ptr [ebp + ecx*4 - 0x124], edx
FFE1C674  ebcc                     jmp 0xffe1c642
FFE1C676  c785fcfeffff00000000     mov dword ptr [ebp - 0x104], 0
FFE1C680  eb0f                     jmp 0xffe1c691
FFE1C682  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C688  83c001                   add eax, 1
FFE1C68B  8985fcfeffff             mov dword ptr [ebp - 0x104], eax
FFE1C691  83bdfcfeffff10           cmp dword ptr [ebp - 0x104], 0x10
FFE1C698  7d55                     jge 0xffe1c6ef
FFE1C69A  8b8dfcfeffff             mov ecx, dword ptr [ebp - 0x104]
FFE1C6A0  8b550c                   mov edx, dword ptr [ebp + 0xc]
FFE1C6A3  0fb6048a                 movzx eax, byte ptr [edx + ecx*4]
FFE1C6A7  c1e018                   shl eax, 0x18
FFE1C6AA  8b8dfcfeffff             mov ecx, dword ptr [ebp - 0x104]
FFE1C6B0  8b550c                   mov edx, dword ptr [ebp + 0xc]
FFE1C6B3  0fb64c8a01               movzx ecx, byte ptr [edx + ecx*4 + 1]
FFE1C6B8  c1e110                   shl ecx, 0x10
FFE1C6BB  0bc1                     or eax, ecx
FFE1C6BD  8b95fcfeffff             mov edx, dword ptr [ebp - 0x104]
FFE1C6C3  8b4d0c                   mov ecx, dword ptr [ebp + 0xc]
FFE1C6C6  0fb6549102               movzx edx, byte ptr [ecx + edx*4 + 2]
FFE1C6CB  c1e208                   shl edx, 8
FFE1C6CE  0bc2                     or eax, edx
FFE1C6D0  8b8dfcfeffff             mov ecx, dword ptr [ebp - 0x104]
FFE1C6D6  8b550c                   mov edx, dword ptr [ebp + 0xc]
FFE1C6D9  0fb64c8a03               movzx ecx, byte ptr [edx + ecx*4 + 3]
FFE1C6DE  0bc1                     or eax, ecx
FFE1C6E0  8b95fcfeffff             mov edx, dword ptr [ebp - 0x104]
FFE1C6E6  89849500ffffff           mov dword ptr [ebp + edx*4 - 0x100], eax
FFE1C6ED  eb93                     jmp 0xffe1c682
FFE1C6EF  c785fcfeffff10000000     mov dword ptr [ebp - 0x104], 0x10
FFE1C6F9  eb0f                     jmp 0xffe1c70a
FFE1C6FB  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C701  83c001                   add eax, 1
FFE1C704  8985fcfeffff             mov dword ptr [ebp - 0x104], eax
FFE1C70A  83bdfcfeffff40           cmp dword ptr [ebp - 0x104], 0x40
FFE1C711  0f8dde000000             jge 0xffe1c7f5
FFE1C717  8b8dfcfeffff             mov ecx, dword ptr [ebp - 0x104]
FFE1C71D  8b948df8feffff           mov edx, dword ptr [ebp + ecx*4 - 0x108]
FFE1C724  c1ea11                   shr edx, 0x11
FFE1C727  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C72D  8b8c85f8feffff           mov ecx, dword ptr [ebp + eax*4 - 0x108]
FFE1C734  c1e10f                   shl ecx, 0xf
FFE1C737  0bd1                     or edx, ecx
FFE1C739  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C73F  8b8c85f8feffff           mov ecx, dword ptr [ebp + eax*4 - 0x108]
FFE1C746  c1e913                   shr ecx, 0x13
FFE1C749  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C74F  8b8485f8feffff           mov eax, dword ptr [ebp + eax*4 - 0x108]
FFE1C756  c1e00d                   shl eax, 0xd
FFE1C759  0bc8                     or ecx, eax
FFE1C75B  33d1                     xor edx, ecx
FFE1C75D  8b8dfcfeffff             mov ecx, dword ptr [ebp - 0x104]
FFE1C763  8b848df8feffff           mov eax, dword ptr [ebp + ecx*4 - 0x108]
FFE1C76A  c1e80a                   shr eax, 0xa
FFE1C76D  33d0                     xor edx, eax
FFE1C76F  8b8dfcfeffff             mov ecx, dword ptr [ebp - 0x104]
FFE1C775  03948de4feffff           add edx, dword ptr [ebp + ecx*4 - 0x11c]
FFE1C77C  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C782  8b8c85c4feffff           mov ecx, dword ptr [ebp + eax*4 - 0x13c]
FFE1C789  c1e907                   shr ecx, 7
FFE1C78C  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C792  8b8485c4feffff           mov eax, dword ptr [ebp + eax*4 - 0x13c]
FFE1C799  c1e019                   shl eax, 0x19
FFE1C79C  0bc8                     or ecx, eax
FFE1C79E  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C7A4  8b8485c4feffff           mov eax, dword ptr [ebp + eax*4 - 0x13c]
FFE1C7AB  c1e812                   shr eax, 0x12
FFE1C7AE  8bb5fcfeffff             mov esi, dword ptr [ebp - 0x104]
FFE1C7B4  8bb4b5c4feffff           mov esi, dword ptr [ebp + esi*4 - 0x13c]
FFE1C7BB  c1e60e                   shl esi, 0xe
FFE1C7BE  0bc6                     or eax, esi
FFE1C7C0  33c8                     xor ecx, eax
FFE1C7C2  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C7C8  8b8485c4feffff           mov eax, dword ptr [ebp + eax*4 - 0x13c]
FFE1C7CF  c1e803                   shr eax, 3
FFE1C7D2  33c8                     xor ecx, eax
FFE1C7D4  03d1                     add edx, ecx
FFE1C7D6  8b8dfcfeffff             mov ecx, dword ptr [ebp - 0x104]
FFE1C7DC  03948dc0feffff           add edx, dword ptr [ebp + ecx*4 - 0x140]
FFE1C7E3  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C7E9  89948500ffffff           mov dword ptr [ebp + eax*4 - 0x100], edx
FFE1C7F0  e906ffffff               jmp 0xffe1c6fb
FFE1C7F5  c785fcfeffff00000000     mov dword ptr [ebp - 0x104], 0
FFE1C7FF  eb0f                     jmp 0xffe1c810
FFE1C801  8b8dfcfeffff             mov ecx, dword ptr [ebp - 0x104]
FFE1C807  83c101                   add ecx, 1
FFE1C80A  898dfcfeffff             mov dword ptr [ebp - 0x104], ecx
FFE1C810  83bdfcfeffff40           cmp dword ptr [ebp - 0x104], 0x40
FFE1C817  0f8d7d010000             jge 0xffe1c99a
FFE1C81D  8b95ecfeffff             mov edx, dword ptr [ebp - 0x114]
FFE1C823  c1ea06                   shr edx, 6
FFE1C826  8b85ecfeffff             mov eax, dword ptr [ebp - 0x114]
FFE1C82C  c1e01a                   shl eax, 0x1a
FFE1C82F  0bd0                     or edx, eax
FFE1C831  8b8decfeffff             mov ecx, dword ptr [ebp - 0x114]
FFE1C837  c1e90b                   shr ecx, 0xb
FFE1C83A  8b85ecfeffff             mov eax, dword ptr [ebp - 0x114]
FFE1C840  c1e015                   shl eax, 0x15
FFE1C843  0bc8                     or ecx, eax
FFE1C845  33d1                     xor edx, ecx
FFE1C847  8b8decfeffff             mov ecx, dword ptr [ebp - 0x114]
FFE1C84D  c1e919                   shr ecx, 0x19
FFE1C850  8b85ecfeffff             mov eax, dword ptr [ebp - 0x114]
FFE1C856  c1e007                   shl eax, 7
FFE1C859  0bc8                     or ecx, eax
FFE1C85B  33d1                     xor edx, ecx
FFE1C85D  0395f8feffff             add edx, dword ptr [ebp - 0x108]
FFE1C863  8b8df0feffff             mov ecx, dword ptr [ebp - 0x110]
FFE1C869  338df4feffff             xor ecx, dword ptr [ebp - 0x10c]
FFE1C86F  238decfeffff             and ecx, dword ptr [ebp - 0x114]
FFE1C875  338df4feffff             xor ecx, dword ptr [ebp - 0x10c]
FFE1C87B  03d1                     add edx, ecx
FFE1C87D  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C883  031485bcd3e1ff           add edx, dword ptr [eax*4 - 0x1e2c44]
FFE1C88A  8b8dfcfeffff             mov ecx, dword ptr [ebp - 0x104]
FFE1C890  03948d00ffffff           add edx, dword ptr [ebp + ecx*4 - 0x100]
FFE1C897  8995d0feffff             mov dword ptr [ebp - 0x130], edx
FFE1C89D  8b95dcfeffff             mov edx, dword ptr [ebp - 0x124]
FFE1C8A3  c1ea02                   shr edx, 2
FFE1C8A6  8b85dcfeffff             mov eax, dword ptr [ebp - 0x124]
FFE1C8AC  c1e01e                   shl eax, 0x1e
FFE1C8AF  0bd0                     or edx, eax
FFE1C8B1  8b8ddcfeffff             mov ecx, dword ptr [ebp - 0x124]
FFE1C8B7  c1e90d                   shr ecx, 0xd
FFE1C8BA  8b85dcfeffff             mov eax, dword ptr [ebp - 0x124]
FFE1C8C0  c1e013                   shl eax, 0x13
FFE1C8C3  0bc8                     or ecx, eax
FFE1C8C5  33d1                     xor edx, ecx
FFE1C8C7  8b8ddcfeffff             mov ecx, dword ptr [ebp - 0x124]
FFE1C8CD  c1e916                   shr ecx, 0x16
FFE1C8D0  8b85dcfeffff             mov eax, dword ptr [ebp - 0x124]
FFE1C8D6  c1e00a                   shl eax, 0xa
FFE1C8D9  0bc8                     or ecx, eax
FFE1C8DB  33d1                     xor edx, ecx
FFE1C8DD  8b8ddcfeffff             mov ecx, dword ptr [ebp - 0x124]
FFE1C8E3  0b8de0feffff             or ecx, dword ptr [ebp - 0x120]
FFE1C8E9  238de4feffff             and ecx, dword ptr [ebp - 0x11c]
FFE1C8EF  8b85dcfeffff             mov eax, dword ptr [ebp - 0x124]
FFE1C8F5  2385e0feffff             and eax, dword ptr [ebp - 0x120]
FFE1C8FB  0bc8                     or ecx, eax
FFE1C8FD  03d1                     add edx, ecx
FFE1C8FF  8995d8feffff             mov dword ptr [ebp - 0x128], edx
FFE1C905  8b8de8feffff             mov ecx, dword ptr [ebp - 0x118]
FFE1C90B  038dd0feffff             add ecx, dword ptr [ebp - 0x130]
FFE1C911  898de8feffff             mov dword ptr [ebp - 0x118], ecx
FFE1C917  8b95d0feffff             mov edx, dword ptr [ebp - 0x130]
FFE1C91D  0395d8feffff             add edx, dword ptr [ebp - 0x128]
FFE1C923  8995f8feffff             mov dword ptr [ebp - 0x108], edx
FFE1C929  8b85f8feffff             mov eax, dword ptr [ebp - 0x108]
FFE1C92F  8985d4feffff             mov dword ptr [ebp - 0x12c], eax
FFE1C935  8b8df4feffff             mov ecx, dword ptr [ebp - 0x10c]
FFE1C93B  898df8feffff             mov dword ptr [ebp - 0x108], ecx
FFE1C941  8b95f0feffff             mov edx, dword ptr [ebp - 0x110]
FFE1C947  8995f4feffff             mov dword ptr [ebp - 0x10c], edx
FFE1C94D  8b85ecfeffff             mov eax, dword ptr [ebp - 0x114]
FFE1C953  8985f0feffff             mov dword ptr [ebp - 0x110], eax
FFE1C959  8b8de8feffff             mov ecx, dword ptr [ebp - 0x118]
FFE1C95F  898decfeffff             mov dword ptr [ebp - 0x114], ecx
FFE1C965  8b95e4feffff             mov edx, dword ptr [ebp - 0x11c]
FFE1C96B  8995e8feffff             mov dword ptr [ebp - 0x118], edx
FFE1C971  8b85e0feffff             mov eax, dword ptr [ebp - 0x120]
FFE1C977  8985e4feffff             mov dword ptr [ebp - 0x11c], eax
FFE1C97D  8b8ddcfeffff             mov ecx, dword ptr [ebp - 0x124]
FFE1C983  898de0feffff             mov dword ptr [ebp - 0x120], ecx
FFE1C989  8b95d4feffff             mov edx, dword ptr [ebp - 0x12c]
FFE1C98F  8995dcfeffff             mov dword ptr [ebp - 0x124], edx
FFE1C995  e967feffff               jmp 0xffe1c801
FFE1C99A  c785fcfeffff00000000     mov dword ptr [ebp - 0x104], 0
FFE1C9A4  eb0f                     jmp 0xffe1c9b5
FFE1C9A6  8b85fcfeffff             mov eax, dword ptr [ebp - 0x104]
FFE1C9AC  83c001                   add eax, 1
FFE1C9AF  8985fcfeffff             mov dword ptr [ebp - 0x104], eax
FFE1C9B5  83bdfcfeffff08           cmp dword ptr [ebp - 0x104], 8
FFE1C9BC  7d29                     jge 0xffe1c9e7
FFE1C9BE  8b8dfcfeffff             mov ecx, dword ptr [ebp - 0x104]
FFE1C9C4  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1C9C7  8b448a08                 mov eax, dword ptr [edx + ecx*4 + 8]
FFE1C9CB  8b8dfcfeffff             mov ecx, dword ptr [ebp - 0x104]
FFE1C9D1  03848ddcfeffff           add eax, dword ptr [ebp + ecx*4 - 0x124]
FFE1C9D8  8b95fcfeffff             mov edx, dword ptr [ebp - 0x104]
FFE1C9DE  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1C9E1  89449108                 mov dword ptr [ecx + edx*4 + 8], eax
FFE1C9E5  ebbf                     jmp 0xffe1c9a6
FFE1C9E7  33c0                     xor eax, eax
FFE1C9E9  5e                       pop esi
FFE1C9EA  8be5                     mov esp, ebp
FFE1C9EC  5d                       pop ebp
FFE1C9ED  c3                       ret 
FFE1C9EE  cc                       int3 
FFE1C9EF  cc                       int3 
FFE1C9F0  cc                       int3 
FFE1C9F1  cc                       int3 
FFE1C9F2  cc                       int3 
FFE1C9F3  cc                       int3 
FFE1C9F4  cc                       int3 
FFE1C9F5  cc                       int3 
FFE1C9F6  cc                       int3 
FFE1C9F7  cc                       int3 
FFE1C9F8  cc                       int3 
FFE1C9F9  cc                       int3 
FFE1C9FA  cc                       int3 
FFE1C9FB  cc                       int3 
FFE1C9FC  55                       push ebp
FFE1C9FD  8bec                     mov ebp, esp
FFE1C9FF  51                       push ecx
FFE1CA00  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CA03  83782840                 cmp dword ptr [eax + 0x28], 0x40
FFE1CA07  7208                     jb 0xffe1ca11
FFE1CA09  83c8ff                   or eax, 0xffffffff
FFE1CA0C  e907020000               jmp 0xffe1cc18
FFE1CA11  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CA14  8b5128                   mov edx, dword ptr [ecx + 0x28]
FFE1CA17  c1e203                   shl edx, 3
FFE1CA1A  33c0                     xor eax, eax
FFE1CA1C  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CA1F  0311                     add edx, dword ptr [ecx]
FFE1CA21  8b4904                   mov ecx, dword ptr [ecx + 4]
FFE1CA24  13c8                     adc ecx, eax
FFE1CA26  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CA29  8910                     mov dword ptr [eax], edx
FFE1CA2B  894804                   mov dword ptr [eax + 4], ecx
FFE1CA2E  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CA31  8b5128                   mov edx, dword ptr [ecx + 0x28]
FFE1CA34  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CA37  c644102c80               mov byte ptr [eax + edx + 0x2c], 0x80
FFE1CA3C  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CA3F  8b5128                   mov edx, dword ptr [ecx + 0x28]
FFE1CA42  83c201                   add edx, 1
FFE1CA45  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CA48  895028                   mov dword ptr [eax + 0x28], edx
FFE1CA4B  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CA4E  83792838                 cmp dword ptr [ecx + 0x28], 0x38
FFE1CA52  7645                     jbe 0xffe1ca99
FFE1CA54  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CA57  837a2840                 cmp dword ptr [edx + 0x28], 0x40
FFE1CA5B  731f                     jae 0xffe1ca7c
FFE1CA5D  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CA60  8b4828                   mov ecx, dword ptr [eax + 0x28]
FFE1CA63  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CA66  c6440a2c00               mov byte ptr [edx + ecx + 0x2c], 0
FFE1CA6B  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CA6E  8b4828                   mov ecx, dword ptr [eax + 0x28]
FFE1CA71  83c101                   add ecx, 1
FFE1CA74  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CA77  894a28                   mov dword ptr [edx + 0x28], ecx
FFE1CA7A  ebd8                     jmp 0xffe1ca54
FFE1CA7C  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CA7F  83c02c                   add eax, 0x2c
FFE1CA82  50                       push eax
FFE1CA83  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CA86  51                       push ecx
FFE1CA87  e8a0fbffff               call 0xffe1c62c
FFE1CA8C  83c408                   add esp, 8
FFE1CA8F  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CA92  c7422800000000           mov dword ptr [edx + 0x28], 0
FFE1CA99  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CA9C  83782838                 cmp dword ptr [eax + 0x28], 0x38
FFE1CAA0  731f                     jae 0xffe1cac1
FFE1CAA2  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CAA5  8b5128                   mov edx, dword ptr [ecx + 0x28]
FFE1CAA8  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CAAB  c644102c00               mov byte ptr [eax + edx + 0x2c], 0
FFE1CAB0  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CAB3  8b5128                   mov edx, dword ptr [ecx + 0x28]
FFE1CAB6  83c201                   add edx, 1
FFE1CAB9  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CABC  895028                   mov dword ptr [eax + 0x28], edx
FFE1CABF  ebd8                     jmp 0xffe1ca99
FFE1CAC1  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CAC4  8b01                     mov eax, dword ptr [ecx]
FFE1CAC6  8b5104                   mov edx, dword ptr [ecx + 4]
FFE1CAC9  b138                     mov cl, 0x38
FFE1CACB  e84c010000               call 0xffe1cc1c
FFE1CAD0  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CAD3  884264                   mov byte ptr [edx + 0x64], al
FFE1CAD6  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CAD9  8b01                     mov eax, dword ptr [ecx]
FFE1CADB  8b5104                   mov edx, dword ptr [ecx + 4]
FFE1CADE  b130                     mov cl, 0x30
FFE1CAE0  e837010000               call 0xffe1cc1c
FFE1CAE5  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CAE8  884265                   mov byte ptr [edx + 0x65], al
FFE1CAEB  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CAEE  8b01                     mov eax, dword ptr [ecx]
FFE1CAF0  8b5104                   mov edx, dword ptr [ecx + 4]
FFE1CAF3  b128                     mov cl, 0x28
FFE1CAF5  e822010000               call 0xffe1cc1c
FFE1CAFA  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CAFD  884266                   mov byte ptr [edx + 0x66], al
FFE1CB00  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CB03  8b01                     mov eax, dword ptr [ecx]
FFE1CB05  8b5104                   mov edx, dword ptr [ecx + 4]
FFE1CB08  b120                     mov cl, 0x20
FFE1CB0A  e80d010000               call 0xffe1cc1c
FFE1CB0F  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CB12  884267                   mov byte ptr [edx + 0x67], al
FFE1CB15  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CB18  8b01                     mov eax, dword ptr [ecx]
FFE1CB1A  8b5104                   mov edx, dword ptr [ecx + 4]
FFE1CB1D  b118                     mov cl, 0x18
FFE1CB1F  e8f8000000               call 0xffe1cc1c
FFE1CB24  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CB27  884268                   mov byte ptr [edx + 0x68], al
FFE1CB2A  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CB2D  8b01                     mov eax, dword ptr [ecx]
FFE1CB2F  8b5104                   mov edx, dword ptr [ecx + 4]
FFE1CB32  b110                     mov cl, 0x10
FFE1CB34  e8e3000000               call 0xffe1cc1c
FFE1CB39  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CB3C  884269                   mov byte ptr [edx + 0x69], al
FFE1CB3F  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CB42  8b01                     mov eax, dword ptr [ecx]
FFE1CB44  8b5104                   mov edx, dword ptr [ecx + 4]
FFE1CB47  b108                     mov cl, 8
FFE1CB49  e8ce000000               call 0xffe1cc1c
FFE1CB4E  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CB51  88426a                   mov byte ptr [edx + 0x6a], al
FFE1CB54  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CB57  8b08                     mov ecx, dword ptr [eax]
FFE1CB59  81e1ff000000             and ecx, 0xff
FFE1CB5F  8b5004                   mov edx, dword ptr [eax + 4]
FFE1CB62  83e200                   and edx, 0
FFE1CB65  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CB68  88486b                   mov byte ptr [eax + 0x6b], cl
FFE1CB6B  33c9                     xor ecx, ecx
FFE1CB6D  0f854effffff             jne 0xffe1cac1
FFE1CB73  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CB76  83c22c                   add edx, 0x2c
FFE1CB79  52                       push edx
FFE1CB7A  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CB7D  50                       push eax
FFE1CB7E  e8a9faffff               call 0xffe1c62c
FFE1CB83  83c408                   add esp, 8
FFE1CB86  c745fc00000000           mov dword ptr [ebp - 4], 0
FFE1CB8D  eb09                     jmp 0xffe1cb98
FFE1CB8F  8b4dfc                   mov ecx, dword ptr [ebp - 4]
FFE1CB92  83c101                   add ecx, 1
FFE1CB95  894dfc                   mov dword ptr [ebp - 4], ecx
FFE1CB98  837dfc08                 cmp dword ptr [ebp - 4], 8
FFE1CB9C  7d78                     jge 0xffe1cc16
FFE1CB9E  8b55fc                   mov edx, dword ptr [ebp - 4]
FFE1CBA1  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CBA4  8b4c9008                 mov ecx, dword ptr [eax + edx*4 + 8]
FFE1CBA8  c1e918                   shr ecx, 0x18
FFE1CBAB  81e1ff000000             and ecx, 0xff
FFE1CBB1  8b55fc                   mov edx, dword ptr [ebp - 4]
FFE1CBB4  8b450c                   mov eax, dword ptr [ebp + 0xc]
FFE1CBB7  880c90                   mov byte ptr [eax + edx*4], cl
FFE1CBBA  8b4dfc                   mov ecx, dword ptr [ebp - 4]
FFE1CBBD  8b5508                   mov edx, dword ptr [ebp + 8]
FFE1CBC0  8b448a08                 mov eax, dword ptr [edx + ecx*4 + 8]
FFE1CBC4  c1e810                   shr eax, 0x10
FFE1CBC7  25ff000000               and eax, 0xff
FFE1CBCC  8b4dfc                   mov ecx, dword ptr [ebp - 4]
FFE1CBCF  8b550c                   mov edx, dword ptr [ebp + 0xc]
FFE1CBD2  88448a01                 mov byte ptr [edx + ecx*4 + 1], al
FFE1CBD6  8b45fc                   mov eax, dword ptr [ebp - 4]
FFE1CBD9  8b4d08                   mov ecx, dword ptr [ebp + 8]
FFE1CBDC  8b548108                 mov edx, dword ptr [ecx + eax*4 + 8]
FFE1CBE0  c1ea08                   shr edx, 8
FFE1CBE3  81e2ff000000             and edx, 0xff
FFE1CBE9  8b45fc                   mov eax, dword ptr [ebp - 4]
FFE1CBEC  8b4d0c                   mov ecx, dword ptr [ebp + 0xc]
FFE1CBEF  88548102                 mov byte ptr [ecx + eax*4 + 2], dl
FFE1CBF3  8b55fc                   mov edx, dword ptr [ebp - 4]
FFE1CBF6  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CBF9  8b4c9008                 mov ecx, dword ptr [eax + edx*4 + 8]
FFE1CBFD  81e1ff000000             and ecx, 0xff
FFE1CC03  8b55fc                   mov edx, dword ptr [ebp - 4]
FFE1CC06  8b450c                   mov eax, dword ptr [ebp + 0xc]
FFE1CC09  884c9003                 mov byte ptr [eax + edx*4 + 3], cl
FFE1CC0D  33c9                     xor ecx, ecx
FFE1CC0F  758d                     jne 0xffe1cb9e
FFE1CC11  e979ffffff               jmp 0xffe1cb8f
FFE1CC16  33c0                     xor eax, eax
FFE1CC18  8be5                     mov esp, ebp
FFE1CC1A  5d                       pop ebp
FFE1CC1B  c3                       ret 
FFE1CC1C  55                       push ebp
FFE1CC1D  8bec                     mov ebp, esp
FFE1CC1F  53                       push ebx
FFE1CC20  33db                     xor ebx, ebx
FFE1CC22  f6c120                   test cl, 0x20
FFE1CC25  0f45c2                   cmovne eax, edx
FFE1CC28  0f45d3                   cmovne edx, ebx
FFE1CC2B  0fadd0                   shrd eax, edx, cl
FFE1CC2E  d3ea                     shr edx, cl
FFE1CC30  5b                       pop ebx
FFE1CC31  5d                       pop ebp
FFE1CC32  c3                       ret 
FFE1CC33  cc                       int3 
FFE1CC34  cc                       int3 
FFE1CC35  cc                       int3 
FFE1CC36  cc                       int3 
FFE1CC37  cc                       int3 
FFE1CC38  cc                       int3 
FFE1CC39  cc                       int3 
FFE1CC3A  cc                       int3 
FFE1CC3B  cc                       int3 
FFE1CC3C  8b4c240c                 mov ecx, dword ptr [esp + 0xc]
FFE1CC40  8a442408                 mov al, byte ptr [esp + 8]
FFE1CC44  eb08                     jmp 0xffe1cc4e
FFE1CC46  8b4c2408                 mov ecx, dword ptr [esp + 8]
FFE1CC4A  8a44240c                 mov al, byte ptr [esp + 0xc]
FFE1CC4E  57                       push edi
FFE1CC4F  8b7c2408                 mov edi, dword ptr [esp + 8]
FFE1CC53  ff742408                 push dword ptr [esp + 8]
FFE1CC57  53                       push ebx
FFE1CC58  8ae0                     mov ah, al
FFE1CC5A  668bd8                   mov bx, ax
FFE1CC5D  c1e010                   shl eax, 0x10
FFE1CC60  668bc3                   mov ax, bx
FFE1CC63  83f904                   cmp ecx, 4
FFE1CC66  7220                     jb 0xffe1cc88
FFE1CC68  8bd7                     mov edx, edi
FFE1CC6A  83e203                   and edx, 3
FFE1CC6D  740d                     je 0xffe1cc7c
FFE1CC6F  f7da                     neg edx
FFE1CC71  83c204                   add edx, 4
FFE1CC74  87ca                     xchg edx, ecx
FFE1CC76  2bd1                     sub edx, ecx
FFE1CC78  f3aa                     rep stosb byte ptr es:[edi], al
FFE1CC7A  8bca                     mov ecx, edx
FFE1CC7C  8bd1                     mov edx, ecx
FFE1CC7E  c1e902                   shr ecx, 2
FFE1CC81  f3ab                     rep stosd dword ptr es:[edi], eax
FFE1CC83  83e203                   and edx, 3
FFE1CC86  8bca                     mov ecx, edx
FFE1CC88  f3aa                     rep stosb byte ptr es:[edi], al
FFE1CC8A  5b                       pop ebx
FFE1CC8B  58                       pop eax
FFE1CC8C  5f                       pop edi
FFE1CC8D  c3                       ret 
FFE1CC8E  cc                       int3 
FFE1CC8F  cc                       int3 
FFE1CC90  cc                       int3 
FFE1CC91  cc                       int3 
FFE1CC92  cc                       int3 
FFE1CC93  cc                       int3 
FFE1CC94  cc                       int3 
FFE1CC95  cc                       int3 
FFE1CC96  cc                       int3 
FFE1CC97  cc                       int3 
FFE1CC98  cc                       int3 
FFE1CC99  cc                       int3 
FFE1CC9A  cc                       int3 
FFE1CC9B  cc                       int3 
FFE1CC9C  55                       push ebp
FFE1CC9D  8bec                     mov ebp, esp
FFE1CC9F  57                       push edi
FFE1CCA0  56                       push esi
FFE1CCA1  53                       push ebx
FFE1CCA2  669c                     pushf 
FFE1CCA4  ff7508                   push dword ptr [ebp + 8]
FFE1CCA7  8b750c                   mov esi, dword ptr [ebp + 0xc]
FFE1CCAA  8b7d08                   mov edi, dword ptr [ebp + 8]
FFE1CCAD  8b4d10                   mov ecx, dword ptr [ebp + 0x10]
FFE1CCB0  b200                     mov dl, 0
FFE1CCB2  8bc6                     mov eax, esi
FFE1CCB4  2bc7                     sub eax, edi
FFE1CCB6  7311                     jae 0xffe1ccc9
FFE1CCB8  8d1c31                   lea ebx, [ecx + esi]
FFE1CCBB  f7d8                     neg eax
FFE1CCBD  3bdf                     cmp ebx, edi
FFE1CCBF  7208                     jb 0xffe1ccc9
FFE1CCC1  8bf3                     mov esi, ebx
FFE1CCC3  8d3c39                   lea edi, [ecx + edi]
FFE1CCC6  b201                     mov dl, 1
FFE1CCC8  fd                       std 
FFE1CCC9  83f904                   cmp ecx, 4
FFE1CCCC  724f                     jb 0xffe1cd1d
FFE1CCCE  83f804                   cmp eax, 4
FFE1CCD1  724a                     jb 0xffe1cd1d
FFE1CCD3  8bc6                     mov eax, esi
FFE1CCD5  8bdf                     mov ebx, edi
FFE1CCD7  83e003                   and eax, 3
FFE1CCDA  83e303                   and ebx, 3
FFE1CCDD  84d2                     test dl, dl
FFE1CCDF  7402                     je 0xffe1cce3
FFE1CCE1  4e                       dec esi
FFE1CCE2  4f                       dec edi
FFE1CCE3  3bc3                     cmp eax, ebx
FFE1CCE5  7514                     jne 0xffe1ccfb
FFE1CCE7  85c0                     test eax, eax
FFE1CCE9  7410                     je 0xffe1ccfb
FFE1CCEB  84d2                     test dl, dl
FFE1CCED  7505                     jne 0xffe1ccf4
FFE1CCEF  f7d8                     neg eax
FFE1CCF1  83c004                   add eax, 4
FFE1CCF4  91                       xchg ecx, eax
FFE1CCF5  2bc1                     sub eax, ecx
FFE1CCF7  f3a4                     rep movsb byte ptr es:[edi], byte ptr [esi]
FFE1CCF9  8bc8                     mov ecx, eax
FFE1CCFB  84d2                     test dl, dl
FFE1CCFD  7406                     je 0xffe1cd05
FFE1CCFF  83ee03                   sub esi, 3
FFE1CD02  83ef03                   sub edi, 3
FFE1CD05  8bc1                     mov eax, ecx
FFE1CD07  c1e902                   shr ecx, 2
FFE1CD0A  f3a5                     rep movsd dword ptr es:[edi], dword ptr [esi]
FFE1CD0C  83e003                   and eax, 3
FFE1CD0F  7414                     je 0xffe1cd25
FFE1CD11  84d2                     test dl, dl
FFE1CD13  7406                     je 0xffe1cd1b
FFE1CD15  83c604                   add esi, 4
FFE1CD18  83c704                   add edi, 4
FFE1CD1B  8bc8                     mov ecx, eax
FFE1CD1D  84d2                     test dl, dl
FFE1CD1F  7402                     je 0xffe1cd23
FFE1CD21  4e                       dec esi
FFE1CD22  4f                       dec edi
FFE1CD23  f3a4                     rep movsb byte ptr es:[edi], byte ptr [esi]
FFE1CD25  58                       pop eax
FFE1CD26  669d                     popf 
FFE1CD28  5b                       pop ebx
FFE1CD29  5e                       pop esi
FFE1CD2A  5f                       pop edi
FFE1CD2B  c9                       leave 
FFE1CD2C  c3                       ret 
FFE1CD2D  cc                       int3 
FFE1CD2E  cc                       int3 
FFE1CD2F  cc                       int3 
FFE1CD30  cc                       int3 
FFE1CD31  cc                       int3 
FFE1CD32  cc                       int3 
FFE1CD33  cc                       int3 
FFE1CD34  cc                       int3 
FFE1CD35  cc                       int3 
FFE1CD36  cc                       int3 
FFE1CD37  cc                       int3 
FFE1CD38  cc                       int3 
FFE1CD39  cc                       int3 
FFE1CD3A  cc                       int3 
FFE1CD3B  cc                       int3 
FFE1CD3C  55                       push ebp
FFE1CD3D  8bec                     mov ebp, esp
FFE1CD3F  8b4508                   mov eax, dword ptr [ebp + 8]
FFE1CD42  0f22d8                   mov cr3, eax
FFE1CD45  0f20e0                   mov eax, cr4
FFE1CD48  660d2006                 or ax, 0x620
FFE1CD4C  0f22e0                   mov cr4, eax
FFE1CD4F  b9800000c0               mov ecx, 0xc0000080
FFE1CD54  0f32                     rdmsr 
FFE1CD56  0fbae808                 bts eax, 8
FFE1CD5A  0f30                     wrmsr 
FFE1CD5C  0f20c0                   mov eax, cr0
FFE1CD5F  0fbae81f                 bts eax, 0x1f
FFE1CD63  0f22c0                   mov cr0, eax
FFE1CD66  eb00                     jmp 0xffe1cd68
FFE1CD68  67ea70cde1ff3800         ljmp 0x38:0xffe1cd70
FFE1CD70  48                       dec eax
FFE1CD71  33c0                     xor eax, eax
FFE1CD73  48                       dec eax
FFE1CD74  33db                     xor ebx, ebx
FFE1CD76  48                       dec eax
FFE1CD77  33c9                     xor ecx, ecx
FFE1CD79  48                       dec eax
FFE1CD7A  33d2                     xor edx, edx
FFE1CD7C  8b4d10                   mov ecx, dword ptr [ebp + 0x10]
FFE1CD7F  8b5514                   mov edx, dword ptr [ebp + 0x14]
FFE1CD82  8b5d0c                   mov ebx, dword ptr [ebp + 0xc]
FFE1CD85  66b83000                 mov ax, 0x30
FFE1CD89  668ed8                   mov ds, ax
FFE1CD8C  668ec0                   mov es, ax
FFE1CD8F  668ed0                   mov ss, ax
FFE1CD92  687f030000               push 0x37f
FFE1CD97  d92c24                   fldcw word ptr [esp]
FFE1CD9A  48                       dec eax
FFE1CD9B  83c408                   add esp, 8
FFE1CD9E  b8f0ffffff               mov eax, 0xfffffff0
FFE1CDA3  48                       dec eax
FFE1CDA4  23e0                     and esp, eax
FFE1CDA6  ffd3                     call ebx
FFE1CDA8  c9                       leave 
FFE1CDA9  c3                       ret 
FFE1CDAA  cc                       int3 
FFE1CDAB  cc                       int3 
FFE1CDAC  57                       push edi
FFE1CDAD  8b442410                 mov eax, dword ptr [esp + 0x10]
FFE1CDB1  8b7c2408                 mov edi, dword ptr [esp + 8]
FFE1CDB5  8b4c240c                 mov ecx, dword ptr [esp + 0xc]
FFE1CDB9  f3aa                     rep stosb byte ptr es:[edi], al
FFE1CDBB  8b442408                 mov eax, dword ptr [esp + 8]
FFE1CDBF  5f                       pop edi
FFE1CDC0  c3                       ret 
FFE1CDC1  cc                       int3 
FFE1CDC2  cc                       int3 
FFE1CDC3  cc                       int3 
FFE1CDC4  57                       push edi
FFE1CDC5  8b442410                 mov eax, dword ptr [esp + 0x10]
FFE1CDC9  8b7c2408                 mov edi, dword ptr [esp + 8]
FFE1CDCD  8b4c240c                 mov ecx, dword ptr [esp + 0xc]
FFE1CDD1  f3ab                     rep stosd dword ptr es:[edi], eax
FFE1CDD3  8b442408                 mov eax, dword ptr [esp + 8]
FFE1CDD7  5f                       pop edi
FFE1CDD8  c3                       ret 
FFE1CDD9  cc                       int3 
FFE1CDDA  cc                       int3 
FFE1CDDB  cc                       int3 
FFE1CDDC  57                       push edi
FFE1CDDD  8b4c240c                 mov ecx, dword ptr [esp + 0xc]
FFE1CDE1  8b442410                 mov eax, dword ptr [esp + 0x10]
FFE1CDE5  8b542414                 mov edx, dword ptr [esp + 0x14]
FFE1CDE9  8b7c2408                 mov edi, dword ptr [esp + 8]
FFE1CDED  8944cff8                 mov dword ptr [edi + ecx*8 - 8], eax
FFE1CDF1  8954cffc                 mov dword ptr [edi + ecx*8 - 4], edx
FFE1CDF5  e2f6                     loop 0xffe1cded
FFE1CDF7  8bc7                     mov eax, edi
FFE1CDF9  5f                       pop edi
FFE1CDFA  c3                       ret 