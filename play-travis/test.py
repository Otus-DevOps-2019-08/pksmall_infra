import unittest

class NumbersTest(unittest.TestCase):

    def test_equal(self):
        self.assertEqual(1 + 1, 1)

    def test_notequal(self):
        self.assertEqual(1 + 2, 1)

if __name__ == '__main__':
    unittest.main()
