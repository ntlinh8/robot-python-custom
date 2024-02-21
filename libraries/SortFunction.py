from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword, library

@library
class SortFunction:

    @property
    def selenium_instance(self):
        return BuiltIn().get_library_instance("SeleniumLibrary")

    @keyword
    def verify_sort_function_properly_work(self, sort_option: str):
        actual_list = []
        if sort_option.startswith("Name"):
            element_list: list = self.selenium_instance.get_webelements("//h2[@class='product-title']/a")
            for element in element_list:
                text = element.text
                actual_list.append(text)
            expected_list: list = actual_list.copy()
            expected_list.sort()
            if "Z to A" in sort_option:
                expected_list.sort(reverse=True)
            if actual_list == expected_list:
                return
        elif sort_option.startswith("Price"):
            element_list: list = self.selenium_instance.get_webelements("//div[@class='prices']/span")
            for element in element_list:
                text: str = element.text
                text = text.replace("$", "").replace(",", "")
                value: float = float(text)
                actual_list.append(value)
            expected_list: list = actual_list.copy()
            expected_list.sort()
            if "High to Low" in sort_option:
                expected_list.sort(reverse=True)
            if actual_list == expected_list:
                return
        else:
            raise Exception("Sorry, this value cannot support")
