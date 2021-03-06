require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::GoldenImage
RSpec.describe klass do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = klass.new(@client_i3s_300)
      expect(item['type']).to eq('GoldenImage')
    end
  end

  describe '#create' do
    it 'generates exception when setting a nonexistent os volume' do
      item = klass.new(@client_i3s_300)
      data = { 'name' => 'volume1' }
      expect(OneviewSDK::ImageStreamer::API300::OSVolume).to receive(:find_by).and_return([instance_double('bp', 'data' => data)])
      expect { item.set_os_volume(OneviewSDK::ImageStreamer::API300::OSVolume.new(@client_i3s_300, name: 'volume1')) }
        .to raise_error(OneviewSDK::NotFound, /The os volume was not found/)
    end

    it 'sets an os volume successfully' do
      os_volume = OneviewSDK::ImageStreamer::API300::OSVolume.new(@client_i3s_300, uri: 'rest/os-volumes/fake')
      item = klass.new(@client_i3s_300)
      expect { item.set_os_volume(os_volume) }.not_to raise_error
      expect(item['osVolumeURI']).to eq('rest/os-volumes/fake')
    end

    it 'sets an os volume with name attribute successfully' do
      os_volume = OneviewSDK::ImageStreamer::API300::OSVolume.new(@client_i3s_300, name: 'volume1')
      data = { 'name' => 'volume', 'uri' => 'rest/os-volumes/fake' }
      expect(OneviewSDK::ImageStreamer::API300::OSVolume).to receive(:find_by).and_return([instance_double('bp', 'data' => data)])
      item = klass.new(@client_i3s_300)
      expect { item.set_os_volume(os_volume) }.not_to raise_error
      expect(item['osVolumeURI']).to eq('rest/os-volumes/fake')
    end

    it 'generates exception when setting a nonexistent build plan' do
      item = klass.new(@client_i3s_300)
      data = { 'name' => 'build_plan1' }
      expect(OneviewSDK::ImageStreamer::API300::BuildPlan).to receive(:find_by).and_return([instance_double('bp', 'data' => data)])
      expect { item.set_build_plan(OneviewSDK::ImageStreamer::API300::BuildPlan.new(@client_i3s_300, name: 'build_plan1')) }
        .to raise_error(OneviewSDK::NotFound, /The build plan was not found/)
    end

    it 'sets a build plan successfully' do
      build_plan = OneviewSDK::ImageStreamer::API300::BuildPlan.new(@client_i3s_300, uri: 'rest/build-plans/fake')
      item = klass.new(@client_i3s_300)
      expect { item.set_build_plan(build_plan) }.not_to raise_error
      expect(item['buildPlanUri']).to eq('rest/build-plans/fake')
    end

    it 'sets a build plan with name attribute successfully' do
      build_plan = OneviewSDK::ImageStreamer::API300::BuildPlan.new(@client_i3s_300, name: 'build_plan1')
      data = { 'name' => 'volume', 'uri' => 'rest/build-plans/fake' }
      expect(OneviewSDK::ImageStreamer::API300::BuildPlan).to receive(:find_by).and_return([instance_double('bp', 'data' => data)])
      item = klass.new(@client_i3s_300)
      expect { item.set_build_plan(build_plan) }.not_to raise_error
      expect(item['buildPlanUri']).to eq('rest/build-plans/fake')
    end
  end

  describe '#add' do
    it 'raises an exception when name of the golden image is not informed with hash keys symbols' do
      allow(File).to receive(:file?).and_return(true)
      options = { description: 'anything' }
      expect { klass.add(@client_i3s_300, 'file.zip', options) }.to raise_error(OneviewSDK::IncompleteResource, /Please set the name/)
    end

    it 'raises an exception when name of the golden image is not informed with hash keys string' do
      allow(File).to receive(:file?).and_return(true)
      options = { 'description' => 'anything' }
      expect { klass.add(@client_i3s_300, 'file.zip', options) }.to raise_error(OneviewSDK::IncompleteResource, /Please set the name/)
    end

    it 'raises an exception when description of the golden image is not informed hash keys symbols' do
      allow(File).to receive(:file?).and_return(true)
      options = { name: 'image1' }
      expect { klass.add(@client_i3s_300, 'file.zip', options) }.to raise_error(OneviewSDK::IncompleteResource, /Please set the description/)
    end

    it 'raises an exception when description of the golden image is not informed hash keys string' do
      allow(File).to receive(:file?).and_return(true)
      options = { 'name' => 'image1' }
      expect { klass.add(@client_i3s_300, 'file.zip', options) }.to raise_error(OneviewSDK::IncompleteResource, /Please set the description/)
    end

    it 'raises an exception when file with extension unsupported' do
      allow(File).to receive(:file?).and_return(true)
      expect { klass.add(@client_i3s_300, 'file.fake', {}) }.to raise_error(OneviewSDK::InvalidFormat, /File with extension/)
    end

    it 'should use default http read_timeout when new value is not passed as parameter' do
      options = { name: 'image1', description: 'anything' }
      expected_options = { 'body' => { 'name' => 'image1', 'description' => 'anything' } }
      expect(@client_i3s_300).to receive(:upload_file).with('file.zip', '/rest/golden-images', expected_options, OneviewSDK::Rest::READ_TIMEOUT)
        .and_return({})
      klass.add(@client_i3s_300, 'file.zip', options)
    end

    it 'should use value of http read_timeout passed as parameter' do
      options = { name: 'image1', description: 'anything' }
      expect_options = { 'body' => { 'name' => 'image1', 'description' => 'anything' } }
      expect(@client_i3s_300).to receive(:upload_file).with('file.zip', '/rest/golden-images', expect_options, 600)
        .and_return({})
      klass.add(@client_i3s_300, 'file.zip', options, 600)
    end

    it 'upload of the golden image file' do
      options = { name: 'image1', description: 'anything' }
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(FakeResponse.new({}, 300))
      allow_any_instance_of(Net::HTTP).to receive(:connect).and_return(true)
      allow(@client_i3s_300).to receive(:response_handler).and_return(klass.new(@client_i3s_300, name: 'fake', uri: 'rest/fake/1'))
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:open).with('file.zip').and_yield('FAKE FILE CONTENT')
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      item = klass.add(@client_i3s_300, 'file.zip', options)
      expect(item).to be_an_instance_of(klass)
      expect(item['name']).to eq('fake')
      expect(item['uri']).to eq('rest/fake/1')
    end
  end

  describe '#download_details_archive' do
    it 'raises an exception when uri is empty' do
      item = klass.new(@client_i3s_300)
      expect { item.download_details_archive('path fake') }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'Download the details of the golden image capture logs' do
      file = double('file like object')
      item = klass.new(@client_i3s_300, uri: '/rest/fake')
      res = FakeResponse.new('res', 300)
      allow_any_instance_of(OneviewSDK::ImageStreamer::Client).to receive(:rest_api).with(:get, '/rest/golden-images/archive/fake').and_return(res)
      expect(File).to receive(:open).with('path/fake', 'wb').and_yield(file)
      expect(file).to receive(:write).with(res.body)
      expect(item.download_details_archive('path/fake')).to eq(true)
    end
  end

  describe '#download' do
    it 'raises an exception when uri is empty' do
      item = klass.new(@client_i3s_300)
      expect { item.download('path fake') }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'raises an exception when an error occurs of the unauthorized type' do
      item = klass.new(@client_i3s_300, uri: '/rest/fake')
      res = FakeResponse.new('res', 401)
      allow_any_instance_of(Net::HTTP).to receive(:request).and_yield(res)
      allow_any_instance_of(Net::HTTP).to receive(:connect).and_return(true)
      expect { item.download('path fake') }.to raise_error(OneviewSDK::Unauthorized, /401/)
    end

    it 'raises an exception when an error occurs of the NotFound type' do
      item = klass.new(@client_i3s_300, uri: '/rest/fake')
      res = FakeResponse.new('res', 404)
      allow_any_instance_of(Net::HTTP).to receive(:request).and_yield(res)
      allow_any_instance_of(Net::HTTP).to receive(:connect).and_return(true)
      expect { item.download('path fake') }.to raise_error(OneviewSDK::NotFound, /404/)
    end

    it 'raises an exception when an error occurs of request' do
      item = klass.new(@client_i3s_300, uri: '/rest/fake')
      res = FakeResponse.new('res', 500)
      allow_any_instance_of(Net::HTTP).to receive(:request).and_yield(res)
      allow_any_instance_of(Net::HTTP).to receive(:connect).and_return(true)
      expect { item.download('path fake') }.to raise_error(OneviewSDK::RequestError, /500/)
    end

    it 'Downloads the content of the selected golden image' do
      file = double('file like object')
      item = klass.new(@client_i3s_300, uri: '/rest/fake')
      res = FakeResponse.new('res', 200)
      allow_any_instance_of(Net::HTTP).to receive(:request).and_yield(res)
      allow_any_instance_of(Net::HTTP).to receive(:connect).and_return(true)
      allow(res).to receive(:read_body).and_yield(res.body)
      expect(File).to receive(:open).with('path/fake', 'wb').and_yield(file)
      expect(file).to receive(:write).with(res.body)
      expect(item.download('path/fake')).to eq(true)
    end
  end
end
