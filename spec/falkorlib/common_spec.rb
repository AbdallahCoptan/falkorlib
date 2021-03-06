require 'spec_helper'
require 'tempfile'

describe FalkorLib::Common do

    include FalkorLib::Common

	dir   = Dir.mktmpdir

	before :all do
		FileUtils.touch File.join(dir, 'file1.txt')
		FileUtils.touch File.join(dir, 'file2.txt')
		FileUtils.mkdir File.join(dir, 'dir1')
		FileUtils.mkdir File.join(dir, 'dir2')
	end

    after :all do
        FileUtils.remove_entry_secure dir
    end

	#############################################
    context "Test (common) printing functions" do

        @print_test_conf = {
            :info => {
                :color  => :green,
				:prefix => "[INFO]",
            },
            :warning => {
                :color  => :cyan,
                :prefix => "/!\\ WARNING:",
            },
            :error => {
                :color  => :red,
                :prefix => "*** ERROR ***",
            }
        }

        # Check the color functions
        @print_test_conf.values.collect{ |e| e[:color] }.each do |color|
			it "##{color} - check #{color} text" do
                expect(STDOUT).to receive(:puts).with(send("#{color}", "#{color} text"))
                puts send("#{color}", "#{color} text")
            end
        end

        # Check the prining messages
        @print_test_conf.each do |method,conf|
			it "##{method} - put a #{method} message" do
                expect((method == :error) ? STDERR : STDOUT).to receive(:puts).with(send("#{conf[:color]}", "#{conf[:prefix]} #{method} text"))
                if (method == :error)
                    expect {
                        send("#{method}", "#{method} text")
                    }.to raise_error #(SystemExit)
                else
                    send("#{method}", "#{method} text")
                end
            end
        end

        # Check the ask function
        ['', 'default'].each do |default_answer|
            @query = "Am I a query"
            it "#ask - ask '#{@query}' with default answer '#{default_answer}' and no answer" do
                expect(STDIN).to receive(:gets).and_return('')
                results = capture(:stdout) {
                    answer = ask(@query, default_answer)
                    if default_answer.empty?
                        expect(answer).to be_empty
                    else
                        expect(answer).to eq(default_answer)
                    end
                }
                expect(results).to match(/#{@query}/);
                unless default_answer.empty?
                    expect(results).to match(/Default: #{default_answer}/);
                end
            end
        end

        # Check the really_continue? function
        [ '', 'Yes', 'y', 'Y', 'yes' ].each do |answer|
            it "#really_continue? - should really continue after answer '#{answer}'" do
                expect(STDIN).to receive(:gets).and_return(answer)
                results = capture(:stdout) { really_continue? }
                expect(results).to match(/=> Do you really want to continue/);
                expect(results).to match(/Default: Yes/);
            end
            next if answer.empty?
            it "#really_continue? - should really continue (despite default answer 'No') after answer '#{answer}'" do
                expect(STDIN).to receive(:gets).and_return(answer)
                results = capture(:stdout) { really_continue?('No') }
                expect(results).to match(/=> Do you really want to continue/);
                expect(results).to match(/Default: No/);
            end
        end

        [ '', 'No', 'n', 'N', 'no' ].each do |answer|
            it "#really_continue? - should not continue (despite default answer 'No') and exit after answer '#{answer}'" do
                expect(STDIN).to receive(:gets).and_return(answer)
                results = capture(:stdout) {
                    expect{
                        really_continue?('No')
                    }.to raise_error (SystemExit)
                }
                expect(results).to match(/=> Do you really want to continue/);
                expect(results).to match(/Default: No/);
            end
            next if answer.empty?
            it "#really_continue? - should not continue and exit after answer '#{answer}'" do
                expect(STDIN).to receive(:gets).and_return(answer)
                results = capture(:stdout) {
                    expect{
                        really_continue?
                    }.to raise_error (SystemExit)
                }
                expect(results).to match(/=> Do you really want to continue/);
                expect(results).to match(/Default: Yes/);
            end
        end

        # Check the command? function
        [ 'sqgfyueztruyjf', 'ruby' ].each do |command|
            it "#command? - check the command '#{command}'" do
                expect(command?(command)).to be ((command == 'ruby') ? true : false)
            end
        end
   end

	it "#nice_execute -- check stdout output" do
		b = capture(:stdout) {
			nice_execute("echo toto")
		}
		expect(b.split("\n")).to include '** [out] toto'
	end

	it "#nice_execute -- check stderr output" do
		b = capture(:stderr) {
			nice_execute("echo 'toto' 1>&2")
		}
		expect(b).to eq(red("** [err] toto\n"))
	end

	it "#execute" do
		b = execute("echo toto")
		expect(b.to_i).to eq(0)
	end

	it "#not_implemented" do
		b = capture(:stderr) {
			expect { not_implemented }.to raise_error (SystemExit)
		}
		expect(b).to match(/NOT YET IMPLEMENTED/)
	end

	it "#exec_or_exit - should exit" do
		expect { exec_or_exit "false" }.to raise_error (SystemExit)
	end
	it "#exec_or_exit - should NOT exit" do
		expect { exec_or_exit "true" }.not_to raise_error # (SystemExit)
	end

	it "#execute_in_dir -- should execute the command in /tmp" do
		b = execute_in_dir('/tmp', "pwd | grep -Fq '/tmp'")
		expect(b).to eq(0)
	end


	it "#run -- exucute successfully multiple commands" do
		b = run %{
            echo toto
            echo tata
        }
		expect(b.to_i).to eq(0)
	end


	#############################################
    context "Test (common) YAML functions" do

		it "#load_config - load the correct hash from YAML" do
			file_config = {:domain => "foo.com", :nested => { 'a1' => 2 }}
			allow(YAML).to receive(:load_file).and_return(file_config)
			loaded = load_config('/tmp')  # /tmp to ensure existing target
			expect(loaded).to eq(file_config)
		end

		it "#store_config - should store the correct hash to YAML" do
			file_config = {:domain => "foo.com", :nested => { 'a1' => 2 }}
			f = Tempfile.new('toto')
			store_config(f.path, file_config, { :no_interaction => true })
			copy_file_config = YAML::load_file(f.path)
			expect(copy_file_config).to eq(file_config)
		end

	end

	############################################
	context 'Test list selection functions' do

		it "#list_items - Exit on 0" do
			expect(STDIN).to receive(:gets).and_return('0')
			expect { list_items("#{dir}/*") }.to raise_error (SystemExit)
		end

		it "#list_items -- select files only" do
			expect(STDIN).to receive(:gets).and_return('1')
			f = list_items("#{dir}/*", { :only_files => true })
			expect(f).to match(/\/file.?\.txt$/)
		end

		it "#list_items -- select files only with pattern exclude" do
			expect(STDIN).to receive(:gets).and_return('1')
			f = list_items("#{dir}/*", { :only_files => true, :pattern_exclude => [ 'file1' ] })
			expect(f).to eq("#{dir}/file2.txt")
		end

		it "#list_items -- select dirs only" do
			expect(STDIN).to receive(:gets).and_return('1')
			f = list_items("#{dir}/*", { :only_dirs => true })
			expect(f).to match(/\/dir.?$/)
		end

		it "#list_items -- select dirs only with pattern exclude" do
			expect(STDIN).to receive(:gets).and_return('1')
			f = list_items("#{dir}/*", { :only_dirs => true, :pattern_exclude => [ 'dir1' ] })
			expect(f).to eq("#{dir}/dir2")
		end

		it "#list_items -- exit on empty list" do
			#STDIN.should_receive(:gets).and_return('1')
			expect { list_items("#{dir}/*", { :only_files => true, :pattern_exclude => [ '.*\.txt']}) }.to raise_error (SystemExit)
		end
	end


end
