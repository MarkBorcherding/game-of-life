require './src/game_of_life'

describe 'Game of life' do

  describe World do

    let(:height) { 4 }
    let(:width) { 5 }
    let(:world) { World.new height, width }

    subject { world }

    its(:height) { should == 4 }
    its(:width ) { should == 5 }

    describe 'default cell state' do
      it { world.alive?(0,0).should == false }
    end

    describe 'live!' do
      before { world.live! 1,1 }
      it { world.alive?(1,1).should == true }
    end

    describe 'dead things are not alive' do
      before { world.live! 1,1 }
      it { world.dead?(1,1).should == false }
    end

    describe '#neighbors' do

      describe 'max neighbors' do

        before do
          height.times do |h|
            width.times do |w|
              world.live! h,w
            end
          end
        end

        describe 'corner cell' do
          it { world.living_neighbors(0,0).should == 2 }
        end

        describe 'edge cell' do
          it { world.living_neighbors(0,1).should == 3 }
        end

        describe 'middle cell' do
          it { world.living_neighbors(1,1).should == 4 }
        end

      end

    end

    describe 'under-populated' do

      before do
        world.live! 0,0
        world.live! 0,1
      end

      it { world.over_populated?(0,1).should == true }

    end

    describe 'surviving' do

      describe 'with two neighbors' do
        before do
          world.live! 0,0
          world.live! 0,1
          world.live! 0,2
        end

        it { world.surviving?(0,1).should == true }
      end

      describe 'with three neighbors' do
        before do
          world.live! 0,0
          world.live! 0,1
          world.live! 0,2
          world.live! 1,1
        end
        it { world.surviving?(0,1).should == true }
      end
    end

    describe 'overpopulated' do
      before do
        world.live! 0,1
        world.live! 1,0
        world.live! 1,1
        world.live! 1,2
        world.live! 2,1
      end
      it { world.overpopulated?(1,1).should == true }
    end

    describe 'reporoduces' do
      before do
        world.live! 0,0
        world.live! 0,2
        world.live! 1,1
      end
      it { world.reproduces?(0,1).should == true }
    end

    describe 'next_generation' do
      let(:next_generation) { world.next_generation }
      subject {next_generation}

      its(:height) { should == world.height }
      its(:width) { should == world.width }
    end

    describe 'displaying' do
      describe 'an empty world' do
        it { world.display.should == ".....\n.....\n.....\n.....\n" }
      end

      describe 'a populated world' do
        before do
          world.live! 1,1
          world.live! 3,4
        end
        it { world.display.should == ".....\n.o...\n.....\n....o\n" }
      end
    end
  end
end
