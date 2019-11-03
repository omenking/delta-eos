require_relative '../render_walls'

RSpec.describe RenderWalls do
  context "#render" do
    #let(:data) {
      #[
        #['W','W','W'],
        #['W',' ','W'],
        #['W','W','W']
      #]
    #}
    #let(:rendered) {
      #[
        #'┏━┓',
        #'┃ ┃',
        #'┗━┛'
      #]
    #}
    let(:data2) {
      [
        '  WWWWW  WWWWW  WWWWW    '.split(''),
        '  W   W  W   W  W   W    '.split(''),
        'WWW   WWWW   WWWW   WWWWW'.split(''),
        'W                       W'.split(''),
        'W                        '.split(''),
        'W                       W'.split(''),
        'W                       W'.split(''),
        'W                       W'.split(''),
        'W                       W'.split(''),
        'WWWWWWWWWWW WWWWWWWWWWWWW'.split('')
      ]
    }
    let(:rendered2) {
      [
        '  WWWWW  WWWWW  WWWWW    ',
        '  W   W  W   W  W   W    ',
        'WWW   wWWW   WWwW   WWWWW',
        'W                       W',
        'W                        ',
        'W                       W',
        'W                       W',
        'W                       W',
        'W                       W',
        'WWWWWWWWWWW WWWWWWWWWWWWW'
      ]
    }
    #it { expect(RenderWalls.render(data)).to eql(rendered) }
    it { expect(RenderWalls.render(data2)).to eql(rendered2) }
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
