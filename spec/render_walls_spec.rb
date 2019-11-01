require_relative '../render_walls'

RSpec.describe RenderWalls do
  context "#render" do
    let(:data) {
      [
        ['W','W','W'],
        ['W',' ','W'],
        ['W','W','W']
      ]
    }
    let(:rendered) {
      [
        '┏━┓',
        '┃ ┃',
        '┗━┛'
      ]
    }
    it { expect(RenderWalls.render(data)).to eql(rendered) }
  end

  context '#self.corner_top_left?' do
    let(:data) {
      [
        ['W','W','W'],
        ['W',' ','W'],
        ['W','W','W']
      ]
    }
    let(:columns) { 3 }
    let(:rows)    { 3 }
    it { expect(RenderWalls.corner_top_left?(data,columns,rows,0,0)).to eql(true) }
    it { expect(RenderWalls.corner_top_left?(data,columns,rows,1,0)).to eql(false) }
    it { expect(RenderWalls.corner_top_left?(data,columns,rows,2,0)).to eql(false) }
    it { expect(RenderWalls.corner_top_left?(data,columns,rows,0,1)).to eql(false) }
    it { expect(RenderWalls.corner_top_left?(data,columns,rows,1,1)).to eql(false) }
    it { expect(RenderWalls.corner_top_left?(data,columns,rows,2,1)).to eql(false) }
    it { expect(RenderWalls.corner_top_left?(data,columns,rows,0,2)).to eql(false) }
    it { expect(RenderWalls.corner_top_left?(data,columns,rows,1,2)).to eql(false) }
    it { expect(RenderWalls.corner_top_left?(data,columns,rows,2,2)).to eql(false) }
  end
end
