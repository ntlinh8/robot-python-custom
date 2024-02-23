There're 2 main way to implement library:
1. Independent library: Based on standard libraries of Python 
Eg: You can custom keywords to perform the complex logic with math library, read and verify the specific characteristics of file....
It doesn't depend on any reference libraries in Robot layer. -> Easy to create with module and file, don't need consider about the class structure to make it complecated. That's it. 
-------------------------------------------------------------------------

2. Dependent Library. Based on other libraries of Python. But it can be devided into 2 types:
-------------------------------------------------------------------------

2.1. Libraries depend on the not running libraries in Robot layer (Request, HTTPS libraries)
- You don't need to get the instance of running library from Robot layer
- Just make it by either module or class structures
-------------------------------------------------------------------------

2.2. Libraries depend on the running libraries in Robot layer (Selenium, Appium  libraries)
- Create your own libraries by using the instance of the existing library
- Extend the existing library -> make it to large by add customed keywords or override the existing keywords 
-------------------------------------------------------------------------

The way to extending the libraries depends on the supportion from this library itself. 
Example: 
For Selenium: We can use
--------------

- Plugin API: 
LibraryComponent to create the plugin of Selenium library (add new keywords or override existing keywords) 
When defining the SeleniumLibrary in Robot framework, you need to add the plugin into the library.
You can add one or more plugin into the Selenium, and with each plugin, you also can add the arguments to them
--------------

- Decomposite the Selenium: 
You can extract the Selenium into small pieces and override them.
After that, when you use, you only need add your custom library to your script (without adding Selenium Library)
When you combine both Selenium and your decomposited Selenium, you may meet the failure and it make confuse to debbug. Because you don't have any bride to give the driver instance between each other.
--------------

- Get Instance of library: 
In your custom library, let get the instance of library directly. After that, you can use the function of Selenium to define new keywords. It can be specific for each project.
When using in your Robot script, you need to define it and Selenium at the same time in the Setting table. After combine, the process will be execute like:
Step 01: Create a new instance of SeleniumLibrary
Step 02: Do somethings by performming Selenium keywords in Robot layer
Step 03: After meeting with the custom library, the instance of this library will be defined and the Selenium instance will be gived.
Step 04: In the Python layer of custom library, the correctsponding function will be performed 
Step 05: Return the value to Robot layer
--------------

- Inheritance: 
You can inherit the Selenium library and you can override the existing functions.
So, in the Robot layer, you only need to define the custom library. Don't need define the Selenium library
--------------

- Event Firing Webdriver
To define the pre-steps and post-steps of selenium, you can use the AbstractEventListener. Create the inherited class of this class and override the abstract methods. Whatever you want.




