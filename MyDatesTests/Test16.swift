//
//  Test16.swift
//  MyDatesTests
//
//  Created by Jin on 10/19/24.
//

import Testing

struct Test16 {

    @Test func fail() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        #expect(5 == 1+2+3)
        
        #expect(7 == 1+2+3)
    }

}
