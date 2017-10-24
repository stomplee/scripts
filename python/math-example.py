# Set variables
Cars = 100
SpaceInACar = 4
Drivers = 30
Passengers = 90
CarsNotDriven = Cars-Drivers
CarsDriven = Drivers
CarpoolCapacity = CarsDriven * SpaceInACar
AveragePassengersPerCar = Passengers / CarsDriven

print "There are", Cars, "cars on the lot."
print "There is space for", SpaceInACar,"people in each car."
print "There are",Drivers,"drivers."
print "There are",Passengers,"passengers."
print "There will be",CarsNotDriven,"empty cars today."
print CarpoolCapacity,"people can be carpooled today."
print "The average capacity of each car is",AveragePassengersPerCar,"\b." # the \b is used to delete the blank space that would be printed before the . otherwise
