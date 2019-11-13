ring_rd:
        ;-----------------------------------------
        ; 【スタックフレームの構築】
        ;-----------------------------------------
        push ebp
        mov ebp, esp

        ;-----------------------------------------
        ; 【レジスタの保存】
        ;-----------------------------------------
        push ebx
        push esi
        push edi

        ;-----------------------------------------
        ; 引数を取得
        ;-----------------------------------------
        mov esi, [ebp + 8]
        mov edi, [ebp + 12]

        ;-----------------------------------------
        ; 読み込み位置を確認
        ;-----------------------------------------
        mov eax, 0
        mov ebx, [esi + ring_buff.rp]
        cmp ebx, [esi + ring_buff.wp]
        je .10E

        mov al, [esi + ring_buff.item + ebx]

        mov [edi], al

        inc ebx
        and ebx, RING_INDEX_MASK
        mov [esi + ring_buff.rp], ebx

        mov eax, 1
.10E:

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        pop edi
        pop esi
        pop ebx

        ;-----------------------------------------
        ; 【スタックフレームの破棄】
        ;-----------------------------------------
        mov esp, ebp
        pop ebp

        ret

ring_wr:
        ;-----------------------------------------
        ; 【スタックフレームの構築】
        ;-----------------------------------------
        push ebp
        mov ebp, esp

        ;-----------------------------------------
        ; 【レジスタの保存】
        ;-----------------------------------------
        push ebx
        push ecx
        push esi

        ;-----------------------------------------
        ; 引数を取得
        ;-----------------------------------------
        mov esi, [ebp + 8]

        ;-----------------------------------------
        ; 書き込み位置を確認
        ;-----------------------------------------
        mov eax, 0
        mov ebx, [esi + ring_buff.wp]
        mov ecx, ebx
        inc ecx
        and ecx, RING_INDEX_MASK

        cmp ecx, [esi + ring_buff.rp]
        je .10E

        mov al, [ebp +12]

        mov [esi + ring_buff.item + ebx], al
        mov [esi + ring_buff.wp], ecx
        mov eax, 1
.10E:

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        pop esi
        pop ecx
        pop ebx

        ;-----------------------------------------
        ; 【スタックフレームの破棄】
        ;-----------------------------------------
        mov esp, ebp
        pop ebp

        ret

draw_key:
        ;-----------------------------------------
        ; 【スタックフレームの構築】
        ;-----------------------------------------
        push ebp
        mov ebp, esp

        ;-----------------------------------------
        ; 【レジスタの保存】
        ;-----------------------------------------
        pusha

        ;-----------------------------------------
        ; 引数を取得
        ;-----------------------------------------
        mov edx, [ebp + 8]
        mov edi, [ebp + 12]
        mov esi, [ebp + 16]

        ;-----------------------------------------
        ; リングバッファの情報を取得
        ;-----------------------------------------
        mov ebx, [esi + ring_buff.rp]
        lea esi, [esi + ring_buff.item]
        mov ecx, RING_ITEM_SIZE

        ;-----------------------------------------
        ; 表示
        ;-----------------------------------------
.10L:
        dec ebx
        and ebx, RING_INDEX_MASK
        mov al, [esi + ebx]

        cdecl itoa, eax, .tmp, 2, 16, 0b0100
        cdecl draw_str, edx, edi, 0x02, .tmp

        add edx, 3

        loop .10L
.10E:

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        popa

        ;-----------------------------------------
        ; 【スタックフレームの破棄】
        ;-----------------------------------------
        mov esp, ebp
        pop ebp

        ret

.tmp:   db "-- ", 0
