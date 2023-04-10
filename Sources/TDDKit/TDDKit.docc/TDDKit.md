# ``TDDKit``

Helping you improve the test driven development experience in *Swift*.


## Overview

TDD is a great way to write code. It improves code quality and brings great *joy*. 😊

But it also brings a lot of **boilerplate**. 🤬 

``TDDKit`` is designed with TDD in mind. These opinionated helpers keep 
you writing great tests that are clear, concise and to-the-point.


## Topics

### Essentials
- <doc:GettingStarted>

### Asserting Equal

- <doc:AssertingEqual>
- ``XCTest/XCTestCase/XCTAssertCastEqual(_:_:_:file:line:)``
- ``XCTest/XCTestCase/XCTAssertContainsEqual(_:_:_:file:line:)``
- ``XCTest/XCTestCase/XCTAssertCountEqual(_:_:_:file:line:)``

### Capturing Results

- <doc:CapturingResults>
- ``XCTest/XCTestCase/XCTCaptureError(from:_:file:line:)``
- ``XCTest/XCTestCase/XCTCaptureIsMainThread(for:droppingFirst:when:)``
- ``XCTest/XCTestCase/XCTCaptureOutput(for:droppingFirst:when:)``
- ``XCTest/XCTestCase/XCTCaptureOutput(of:for:droppingFirst:when:)``

### Tracking Memory Leaks

- <doc:TrackingMemoryLeaks>
- ``XCTest/XCTestCase/XCTAssertWillDeallocate(instance:_:file:line:)``

### Utility

- <doc:Utility>
- ``XCTest/XCTestCase/XCTAnyError``
- ``Swift/Collection/subscript(xctIndex:_:_:)``
