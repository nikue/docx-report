require 'rubygems'
#require 'zipruby'
require 'zip/zip'
require 'fileutils'
require 'nokogiri'
require 'tmpdir'

require File.expand_path('../docx-report/parser/default',  __FILE__)
require File.expand_path('../docx-report/images',    __FILE__)
require File.expand_path('../docx-report/field',     __FILE__)
require File.expand_path('../docx-report/text',      __FILE__)
require File.expand_path('../docx-report/file',      __FILE__)
require File.expand_path('../docx-report/fields',    __FILE__)
require File.expand_path('../docx-report/nested',    __FILE__)
require File.expand_path('../docx-report/section',   __FILE__)
require File.expand_path('../docx-report/table',     __FILE__)
require File.expand_path('../docx-report/report',    __FILE__)