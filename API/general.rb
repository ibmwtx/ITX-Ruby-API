
require 'rubygems'
require 'ffi'

module General
	extend FFI::Library
	ffi_lib 'dtxpi'
	
	typedef :int, :MPIRC
	
	attach_function :mpiInitAPI, [:string], :MPIRC
	attach_function :mpiTermAPI, [], :MPIRC
	attach_function :mpiErrorGetText, [:MPIRC], :string
end
