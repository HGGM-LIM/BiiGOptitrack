// This is an example for a source file
// It calculates the square of a number

// Include example header
#include "TestOptitrack.h"

  void TestOptitrack::printConfigVariables(void){

// This line print variables into Config.h header if
// DEBUG_FLAG was set to TRUE during Configuration time
#ifdef TestOptitrack_DEBUG_FLAG

    fprintf(stdout,"The current version of the program %s is: %i.%i\n",
           TestOptitrack_PROJECT_NAME, TestOptitrack_VERSION_MAJOR, TestOptitrack_VERSION_MINOR);
#else

    fprintf(stdout,"printConfigVariables function\n");

#endif
  }

double TestOptitrack::myfunction(double x)
{
  return sqrt(x);
}

// Main Function

int main (int argc, char *argv[])
{

  // Shows the Config.h functionality
  TestOptitrack::printConfigVariables();

  // Uses a function defined in other cpp file of the same project
  double outputValue = TestOptitrack::myfunction(4.0);

  return 0;
}
