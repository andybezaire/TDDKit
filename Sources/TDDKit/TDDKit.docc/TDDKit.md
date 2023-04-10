# ``TDDKit``

A grouping of helpers used to improve the testing experience.


## Overview

TDD is a great way to write code. It improves code quality and brings great joy. 😊

But it also brings a lot of boilerplate. 

These test helpers are designed with TDD in mind. 
They can help with writing tests that are clear and reduce boilerplate code.


## Topics

### Essentials
- <doc:Ge>

### Asserting Equal

- ``XCTest/XCTestCase/XCTAssertCastEqual(_:_:_:file:line:)``
- ``XCTest/XCTestCase/XCTAssertContainsEqual(_:_:_:file:line:)``
- ``XCTest/XCTestCase/XCTAssertCountEqual(_:_:_:file:line:)``

### Capturing Results

- ``XCTest/XCTestCase/XCTCaptureError(from:_:file:line:)``
- ``XCTest/XCTestCase/XCTCaptureIsMainThread(for:droppingFirst:when:)``
- ``XCTest/XCTestCase/XCTCaptureOutput(for:droppingFirst:when:)``
- ``XCTest/XCTestCase/XCTCaptureOutput(of:for:droppingFirst:when:)``

### Tracking Memory Leaks

- ``XCTest/XCTestCase/XCTAssertWillDeallocate(instance:_:file:line:)``

### Utility

- ``XCTest/XCTestCase/XCTAnyError``
- ``Swift/Collection/subscript(xctIndex:_:_:)``
