//
// Created by Koschei on 2025/2/15.
//

#include <mathx.h>
#include <gtest/gtest.h>

TEST(MathxTest, Add) {
    Mathx mathx;
    EXPECT_EQ(3, mathx.add(1, 2));
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
