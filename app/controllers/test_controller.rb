class TestPdf < Prawn::Document
    def initialize
        super()

    # 日本語フォントを使用しないと日本語使えません
    font_families.update('Test' => { normal: 'vendor/fonts/ipaexm.ttf', bold: 'vendor/fonts/ipaexg.ttf' })
    font 'Test'

    # 座標を表示
    stroke_axis

    # 単純なテキストの表示
    text 'Hello Prawn'

    # 単純なテーブルの表示
    # テーブルの要素は2次元配列で定義する
    rows = [
      ['1-1', '1-2'],
      ['2-1', '2-2'],
      ['3-1', '3-2']
    ]
    table rows

    # 下に20
    move_down 20

    # 複雑なテーブルの表示
    rows = [
      [{ content: '1×2の横長', colspan: 2 }, '1-3'],
      [{ content: '2×1の縦長', rowspan: 2 }, '2-2', '2-3'],
      ['3-2', '3-4'],
      [{ content: '2×2のワガママ', colspan: 2, rowspan: 2 }, '4-3'],
      ['5-3']
    ]
    # セルの高さ30、左上詰め詰め
    table rows, cell_style: { height: 50, width: 200, padding: 0 } do
      # 枠線なし
      cells.borders = []
      # 文字サイズ
      cells.size = 20
      # 枠線左と上だけ
      cells.borders = %i[left top]
      # 1行目はセンター寄せ
      row(0).align = :center
      # 1行目の背景色をff7500に
      row(0).background_color = 'ff7500'
      # 1列目の横幅を30に
      columns(0).width = 100
      # 行列の最終の文字を小さく
      columns(-1).row(-1).size = 5
      # 行列の枠は四方固める
      columns(-1).row(-1).borders = %i[top bottom left right]
      # 行列の枠線は点線で
      columns(-1).row(-1).border_lines = %i[dotted]
    end

    # 第一引数の座標にボックスを作る
    bounding_box([100, 350], width: 200, height: 100) do
      # 周りに枠線をつける
      transparent(1) { stroke_bounds }
      font_size 16
      text '太文字', style: :bold
      text 'このボックスの使い勝手はかなりいい'
    end

    # 座標を指定して画像を表示する
    # image 'app/assets/images/me.jpg', at: [10, 200], width: 100
    # image 'app/assets/images/pote.jpg', at: [150, 200], width: 150

    # 座標を指定してテキストを表示する
    draw_text 'ネコと和解せよ', at: [160, 50], size: 30
  end
end

class TestController < ApplicationController
    def index
        respond_to do |format|
            format.pdf do
                test_pdf = TestPdf.new.render
                send_data test_pdf,
                    filename: 'test.pdf',
                    type: 'application/pdf',
                    disposition: 'inline' #　画面に表示
            end
        end
    end
end
