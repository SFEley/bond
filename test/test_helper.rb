require 'rubygems'
require 'test/unit'
require 'context' #gem install jeremymcanally-context -s http://gems.github.com
require 'matchy' #gem install jeremymcanally-matchy -s http://gems.github.com
require 'mocha'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bond'

class Test::Unit::TestCase
  before(:all) {
    # Mock irb
    unless Object.const_defined?(:IRB)
      eval %[
        module ::IRB
          class<<self; attr_accessor :CurrentContext; end
          module InputCompletor; CompletionProc = lambda {|e| [] }; end
        end
      ]
      ::IRB.CurrentContext = stub(:workspace=>stub(:binding=>binding))
    end
  }

  def capture_stderr(&block)
    original_stderr = $stderr
    $stderr = fake = StringIO.new
    begin
      yield
    ensure
      $stderr = original_stderr
    end
    fake.string
  end

  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
    fake.string
  end

  def tabtab(full_line, last_word=full_line)
    Bond.agent.stubs(:line_buffer).returns(full_line)
    Bond.agent.call(last_word)
  end

  def complete(*args, &block)
    Bond.complete(*args, &block)
  end

  def valid_readline_plugin
    Module.new{ def setup; end; def line_buffer; end }
  end
end