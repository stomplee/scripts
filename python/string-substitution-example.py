# use the syntax of var = 'foo' instead of var = "bar" so that you can do things like var = 'foo "cat" bar' 
# instead of having to use escape characters as you would with var = "bar"

# Declare Variables
#
# Note how the numerical values don't have quotes around them.  Put quotes around strings but not integers

name = 'Stomp Lee'
age = 36
eyes = 'Green'
hair = 'Brown'
height = 70 # inches.
weight = 185.5 # lbs
var = 'foo "cat" bar'

# Variable substitution in action
#
# When substituting a string the format character is %s
# When substituting an integer the format character is %d
#
# %d and %i do the same thing they are both integer subs, but do not track decimal points
# To track decimal points us %f which is for floating point decimal ie: 36.000000 years old
#
# %r seems to print the variable itself, ie the contents of the string, refer to example below

print "Let's talk about %s." % name
print "They are %f years old." % age
print "They are %d inches tall." % height
print "They weigh %d pounds." % weight
print "They have %s eyes and %s hair." % (eyes, hair)
# Notice how the following line includes math in the variable list and also uses %f to output the answer
# as a floating point decimal.  The floating point output is pointless in this case as all of the input variables
# are plain integers
print "If I add %d, %d, and %d I get %f." % (age, height, weight, age + height + weight)
# This line will output: Something 'foo "cat" bar'.
print "Something %r." % var
# Where as this line will output: Something foo "cat" bar.
print "Something %s." % var