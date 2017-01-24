//
//  Utilities.swift
//  PerfectLDAP
//
//  Created by Rocky Wei on 2017-01-21.
//	Copyright (C) 2017 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2017 - 2018 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectICONV
import OpenLDAP

extension Iconv {

  /// directly convert a string from a berval structure
  /// - parameters:
  ///   - from: struct berval, pointer to transit
  /// - returns:
  ///   encoded string
  public func convert(from: berval) -> String {
    let (ptr, _) = self.convert(buf: from.bv_val, length: Int(from.bv_len))
    guard let p = ptr else {
      return ""
    }//end guard
    let str = String(validatingUTF8: p)
    p.deallocate(capacity: Int(from.bv_len) * 2)
    return str ?? ""
  }//end convert
}

extension Array {

  /// generic function of converting array to a null terminated pointer array
  /// *CAUTION* memory MUST BE RELEASED MANUALLY
  /// - return:
  ///   a pointer array with each pointer is pointing the corresponding element, ending with a null pointer.
  public func asUnsafeNullTerminatedPointers() -> UnsafeMutablePointer<UnsafeMutablePointer<Element>?> {

    let pArray = self.map { value -> UnsafeMutablePointer<Element>? in
      let p = UnsafeMutablePointer<Element>.allocate(capacity: 1)
      p.initialize(to: value)
      return p
    }//end map

    let pointers = UnsafeMutablePointer<UnsafeMutablePointer<Element>?>.allocate(capacity: self.count + 1)
    pointers.initialize(from: pArray)
    pointers.advanced(by: self.count).pointee = UnsafeMutablePointer<Element>(bitPattern: 0)
    return pointers
  }//func
}//end array