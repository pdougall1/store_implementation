RSpec.describe Store do
  let(:store) { described_class.new(data: hash) }

  let(:path) { [:table_name, :column_name] }

  let(:hash) {{
    table_name: {
      column_name: value
    }
  }}

  let(:value) { 22 }

  describe '#recurse_hash(path, hash)' do
    it 'returns the value' do
      expect(store.recurse_hash(path, hash)).to eq(22)
    end
  
    context 'when an item in the path cannot be found' do
      let(:hash) {{
        table_name: {
          wrong_name: value
        }
      }}
  
      it 'raises an error' do
        expect {
          store.recurse_hash(path, hash)
        }.to raise_error(ArgumentError)
      end
    end

    context 'when the path is empty' do
      let(:path) { [] }
  
      it 'returns the whole store' do
        expect(store.recurse_hash(path, hash)).to eq(hash)
      end
    end
  
    context 'when the hash is really long' do
      let(:path) { [:k1, :k2, :k3, :k4, :k5, :k6] }
  
      let(:hash) {{
        k1: {
          k2: {
            k3: {
              k4: {
                k5: {
                  k6: value
                }
              }
            }
          }
        }
      }}
  
      it 'returns the value' do
        expect(store.recurse_hash(path, hash)).to eq(22)
      end
    end
  
    context 'when there are other keys in the level' do
      let(:hash) {{
        some_meta_data: :perhaps,
        table_name: {
          a_different_column_name: :some_value,
          column_name: value
        }
      }}
      
      it 'returns the value' do
        expect(store.recurse_hash(path, hash)).to eq(22)
      end
    end

    context 'when not the full path' do
      it 'returns the hash at that position' do
        expect(store.recurse_hash([:table_name], hash)).to eq({ column_name: value})
      end
    end
  end

  describe '#read(path)' do
    it 'returns value at the path' do 
      expect(store.read(path)).to eq(22)
    end
  end

  describe '#write(path)' do 
    it 'returns value at the path' do 
      expect {
        store.write(path, 33)
      }.to change { hash }.from(hash).to(
        {:table_name=>{:column_name=>33}}
      )
    end
  end
end