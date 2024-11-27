require 'spec_helper'

RSpec.describe VietnamAddress::ViewHelpers do
  let(:dummy_class) { Class.new { include VietnamAddress::ViewHelpers } }
  let(:helper) { dummy_class.new }
  let(:form) { double('form') }

  describe '#province_select' do
    let(:province) { instance_double(VietnamAddress::Province, id: '01', name: 'Ha Noi') }
    let(:provinces) { [province] }
    let(:options) { { prompt: 'Select Province' } }

    before do
      allow(VietnamAddress::Province).to receive(:all).and_return(provinces)
    end

    it 'generates province select with correct options' do
      expect(form).to receive(:select)
        .with(:province_id, [['Ha Noi', '01']], options)

      helper.province_select(form, options)
    end
  end

  describe '#district_select' do
    let(:province) { instance_double(VietnamAddress::Province, districts: districts) }
    let(:district) { instance_double(VietnamAddress::District, id: '001', name: 'Ba Dinh') }
    let(:districts) { [district] }
    let(:options) { { prompt: 'Select District' } }

    context 'when province_id is provided' do
      before do
        allow(VietnamAddress::Province).to receive(:find_by_id)
          .with('01')
          .and_return(province)
      end

      it 'generates district select with correct options' do
        expect(form).to receive(:select)
          .with(:district_id, [['Ba Dinh', '001']], options)

        helper.district_select(form, '01', options)
      end
    end

    context 'when province_id is nil' do
      it 'generates empty district select' do
        expect(form).to receive(:select)
          .with(:district_id, [], options)

        helper.district_select(form, nil, options)
      end
    end

    context 'when province is not found' do
      before do
        allow(VietnamAddress::Province).to receive(:find_by_id)
          .with('99')
          .and_return(nil)
      end

      it 'generates empty district select' do
        expect(form).to receive(:select)
          .with(:district_id, [], options)

        helper.district_select(form, '99', options)
      end
    end
  end

  describe '#ward_select' do
    let(:district) { instance_double(VietnamAddress::District, wards: wards) }
    let(:ward) { instance_double(VietnamAddress::Ward, id: '001', name: 'Phu Xuyen') }
    let(:wards) { [ward] }
    let(:options) { { prompt: 'Select Ward' } }

    context 'when district_id is provided' do
      before do
        allow(VietnamAddress::District).to receive(:find_by_id)
          .with('001')
          .and_return(district)
      end

      it 'generates ward select with correct options' do
        expect(form).to receive(:select)
          .with(:ward_id, [['Phu Xuyen', '001']], options)

        helper.ward_select(form, '001', options)
      end
    end

    context 'when district_id is nil' do
      it 'generates empty ward select' do
        expect(form).to receive(:select)
          .with(:ward_id, [], options)

        helper.ward_select(form, nil, options)
      end
    end

    context 'when district is not found' do
      before do
        allow(VietnamAddress::District).to receive(:find_by_id)
          .with('999')
          .and_return(nil)
      end

      it 'generates empty ward select' do
        expect(form).to receive(:select)
          .with(:ward_id, [], options)

        helper.ward_select(form, '999', options)
      end
    end
  end
end
