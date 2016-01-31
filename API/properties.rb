
/* 
 * Copyright (C) 2006 - 2014 IBM Corporation.  All rights reserved.
 *
 * This software is the property of IBM Corporation and its
 * licensors and contains their confidential trade secrets.  Use, examination,
 * copying, transfer and disclosure to others, in whole or in part, are
 * prohibited except with the express prior written consent of
 * IBM Corporation.
 *
 */
 
require 'rubygems'
require 'ffi'

module Properties
	extend FFI::Library
	ffi_lib 'dtxpi'
	
	typedef :int, :MPIRC
	typedef :long, :HMPIOBJ
	typedef :pointer, :HMPIOBJP
	typedef :int, :MPIPROP
	
	attach_function :mpiPropertySetInteger, [:HMPIOBJ, :MPIPROP, :int, :int], :MPIRC
	attach_function :mpiPropertySetText, 
					[:HMPIOBJ, :MPIPROP, :int, :string, :size_t], 
					:MPIRC
	attach_function :mpiPropertyGetInteger, [:HMPIOBJ, :MPIPROP, :int, :pointer], :MPIRC
	attach_function :mpiPropertyGetText, 
					[:HMPIOBJ, :MPIPROP, :int, :pointer, :pointer],
					:MPIRC
	attach_function :mpiPropertyGetObject, [:HMPIOBJ, :MPIPROP, :int, :HMPIOBJP], :MPIRC
	attach_function :mpiPropertyGetPropertiesXML,
					[:HMPIOBJ, :pointer, :int, :int, :pointer, :pointer],
					:MPIRC
	attach_function :mpiPropertySetPropertiesXML, [:HMPIOBJ, :string], :MPIRC
	attach_function :mpiPropertyGetAllPropertiesXML, 
					[:HMPIOBJ, :pointer, :pointer, :int],
					:MPIRC
end
