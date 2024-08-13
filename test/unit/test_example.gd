extends GutTest

func before_each():
	print("Testing")
	gut.p("Run before all tests.")

func test_passes():
	assert_eq(1,1)


func test_fails():
	assert_eq("Test", "test2")
