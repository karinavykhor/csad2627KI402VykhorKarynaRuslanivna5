package com.example.hello;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class BasicTest {
    @Test
    void basicAddition() {
        assertEquals(5, Calculator.add(2, 3));
    }
}
