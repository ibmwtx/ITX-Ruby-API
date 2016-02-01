
 
require 'rubygems'
require 'ffi'

module Card
	extend FFI::Library
	ffi_lib 'dtxpi'
	
	typedef :int, :MPIRC
	typedef :long, :HMPICARD
	typedef :pointer, :HMPIADAPT
	typedef :pointer, :HMPIMAP
	
	attach_function :mpiCardGetAdapterObject, [:HMPICARD, :HMPIADAPT], :MPIRC
	attach_function :mpiCardGetMapObject, [:HMPICARD, :HMPIMAP], :MPIRC
	attach_function :mpiCardGetAdapterType, [:HMPICARD, :pointer], :MPIRC
	attach_function :mpiCardOverrideAdapter, [:HMPICARD, :string, :int], :MPIRC
end

