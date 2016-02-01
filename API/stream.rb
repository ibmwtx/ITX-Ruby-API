
require 'rubygems'
require 'ffi'

module Stream
	extend FFI::Library
	ffi_lib 'dtxpi'
	
	typedef :int, :MPIRC
	typedef :long, :HMPISTREAMPAGE
	typedef :pointer, :HMPISTREAMPAGEP
	typedef :long, :HMPISTREAM
	typedef :pointer, :HMPISTREAMP
	
	attach_function :mpiSetGlobalStreamSettings, [:size_t, :string], :MPIRC
	attach_function :mpiStreamPageGetInfo, [:HMPISTREAMPAGE, :pointer, :pointer], :MPIRC
	attach_function :mpiStreamCreate, 
					[:HMPISTREAMP, :size_t, :string, :string, :int],
					:MPIRC
	attach_function :mpiStreamDestroy, [:HMPISTREAM], :MPIRC
	attach_function :mpiStreamModify, 
					[:HMPISTREAM, :size_t, :string, :string, :int],
					:MPIRC
	attach_function :mpiStreamNewPage, [:HMPISTREAM, :HMPISTREAMPAGEP, :size_t], :MPIRC
	attach_function :mpiStreamNewPageCopy, 
					[:HMPISTREAM, :HMPISTREAMPAGEP, :pointer, :size_t],
					:MPIRC
	attach_function :mpiStreamNewPageRef,
					[:HMPISTREAM, :HMPISTREAMPAGEP, :pointer, :size_t],
					:MPIRC
	attach_function :mpiStreamDeletePage, [:HMPISTREAM, :HMPISTREAMPAGE], :MPIRC
	attach_function :mpiStreamWrite, [:HMPISTREAM, :pointer, :size_t], :MPIRC
	attach_function :mpiStreamWritePage, [:HMPISTREAM, :HMPISTREAMPAGE], :MPIRC
	attach_function :mpiStreamWritePageEx, [:HMPISTREAM, :HMPISTREAMPAGE, :size_t], :MPIRC
	attach_function :mpiStreamSeek, [:HMPISTREAM, :size_t, :int], :MPIRC
	attach_function :mpiStreamRead, [:HMPISTREAM, :pointer, :size_t, :pointer], :MPIRC
	attach_function :mpiStreamReadPage, [:HMPISTREAM, :HMPISTREAMPAGEP], :MPIRC
	attach_function :mpiStreamGetSize, [:HMPISTREAM, :pointer], :MPIRC
	attach_function :mpiStreamSetSize, [:HMPISTREAM, :size_t], :MPIRC
	attach_function :mpiStreamFlush, [:HMPISTREAM], :MPIRC
	attach_function :mpiStreamIsEnd, [:HMPISTREAM, :pointer], :MPIRC
	attach_function :mpiStreamTell, [:HMPISTREAM, :pointer], :MPIRC
	attach_function :mpiStreamToFile, [:HMPISTREAM, :string, :int], :MPIRC
	attach_function :mpiStreamGetDelimitedLength, 
					[:HMPISTREAM, :pointer, :pointer, :pointer, :pointer],
					:MPIRC
	
	attach_function :mpiGetHomeDir, [:pointer, :uint], :MPIRC
	attach_function :mpiGetDTXINI, [:pointer, :uint], :MPIRC
	attach_function :mpiSetDTXINI, [:pointer], :MPIRC
end 
