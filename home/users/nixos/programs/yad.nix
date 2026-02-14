{pkgs, ...}: {
  home.packages = with pkgs; [yad];
  home.file.".local/bin/qtilekeys-yad" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # 使用 qtile cmd-obj 取得即時按鍵資料
      # 跳過前兩行標題，並用 Python 精準切開固定寬度的欄位
      qtile cmd-obj -o cmd -f display_kb | python3 -c "
      import sys
      lines = sys.stdin.readlines()[2:]
      for line in lines:
          if len(line.strip()) < 10: continue
          # 根據輸出寬度切片：KeySym(7-20), Mod(20-40), Desc(134 之後)
          keysym = line[7:23].strip()
          mod = line[23:50].strip()
          desc = line[134:].strip()

          # 輸出給 yad 的格式：第一行 Key, 第二行 Desc
          print(f'{mod} + {keysym}')
          print(desc)
      " | yad --list \
          --title="Qtile Live Shortcuts" \
          --width=1000 --height=600 \
          --column="快捷鍵 (Keys)" --column="功能描述 (Description)" \
          --search-column=1 \
          --button="關閉:0" \
          --window-icon="help-about"
    '';
  };
}
