class TestPdf < Prawn::Document
    def initialize
        super()
        # 座標を表示
        stroke_axis
    end
end