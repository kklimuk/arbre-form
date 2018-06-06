RSpec.describe Arbre::Form::Base do
  subject { arbre_context(content, attributes, &body) }

  let(:assigns) { {} }
  let(:content) { '' }
  let(:attributes) { {} }
  let(:body) { proc {} }

  it do
    is_expected.to eq <<~HTML
      <form action="/" method="POST">
        <input type="hidden" name="utf8" value="✓"/>
      </form>
    HTML
  end

  context 'when the method is not allowed' do
    let(:attributes) { { method: :potato } }

    it do
      expect { subject }.to raise_error Arbre::Form::Base::InvalidMethodError
    end
  end

  context 'when the action is set' do
    let(:attributes) { { action: '/papers' } }

    it do
      is_expected.to eq <<~HTML
        <form action="/papers" method="POST">
          <input type="hidden" name="utf8" value="✓"/>
        </form>
      HTML
    end
  end

  context 'when the method is not a standard form method' do
    let(:attributes) { { method: :put } }

    it do
      is_expected.to eq <<~HTML
        <form action="/" method="POST">
          <input type="hidden" name="utf8" value="✓"/>
          <input type="hidden" name="_method" value="PUT"/>
        </form>
      HTML
    end
  end

  context 'when the form is multipart' do
    let(:attributes) { { multipart: true } }

    it do
      is_expected.to eq <<~HTML
        <form action="/" enctype="multipart/form-data" method="POST">
          <input type="hidden" name="utf8" value="✓"/>
        </form>
      HTML
    end
  end

  context 'when utf is not enforced' do
    let(:attributes) { { enforce_utf8: false } }

    it do
      is_expected.to eq <<~HTML
        <form action="/" method="POST"></form>
      HTML
    end
  end

  context 'when there is a remote form' do
    let(:attributes) { { remote: true } }

    it do
      is_expected.to eq <<~HTML
        <form action="/" method="POST" data-remote="true">
          <input type="hidden" name="utf8" value="✓"/>
        </form>
      HTML
    end
  end

  # TODO:
  # context 'when Rails exists' do
  #   before { Object.const_set(:Rails, double) }
  #   after { Object.remove_const(:Rails) }
  #
  #   let(:assigns) { {  } }
  # end
end