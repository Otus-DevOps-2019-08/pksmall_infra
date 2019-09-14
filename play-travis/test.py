import unittest

class NumbersTest(unittest.TestCase):

    def test_equal(self):
        self.assertEqual(1 + 1, 1)

    def test_notequal(self):
        self.assertNotEqual(2, 1)

    def test_gre(self):
        self.assertGreater(1, 2)

if __name__ == '__main__':
    unittest.main()
