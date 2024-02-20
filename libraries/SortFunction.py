from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword, library

@library
class SortFunction:

    @property
    def selenium_instance(self):
        return BuiltIn().get_library_instance("SeleniumLibrary")

    @keyword
    def verify_sort_function_properly_work(self, sort_option: str):
        if sort_option == 'Name: A to Z':
            actual_title = []
            element_list: list = self.selenium_instance.get_webelements("//h2[@class='product-title']/a")
            for element in element_list:
                text = element.text
                actual_title.append(text)
            expected_title: list = actual_title.copy()
            expected_title.sort()
            if actual_title == expected_title:
                return
        elif sort_option == 'Name: Z to A':
            actual_title = []
            element_list: list = self.selenium_instance.get_webelements("//h2[@class='product-title']/a")
            for element in element_list:
                text = element.text
                actual_title.append(text)
            expected_title: list = actual_title.copy()
            expected_title.sort(reverse=true)
            if actual_title == expected_title:
                return
        elif sort_option == 'Price: Low to High':
            pass
        elif sort_option == 'Price: High to Low':
            pass
        else:
            raise Exception("Sorry, this value cannot support")
