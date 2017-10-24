print "Mary had a little lamb."
print "Its fleece was white as %s." % 'snow'
print "And everywhere that Mary went."
print "." * 10 # what does this do? ahh, it tells python to print the string 10 times aka ..........

end1 = 'C'
end2 = 'h'
end3 = 'e'
end4 = 'e'
end5 = 's'
end6 = 'e'
end7 = 'b'
end8 = 'u'
end9 = 'r'
end10 = 'g'
end11 = 'e'
end12 = 'r'

# Note the comma and the end of the line below.

print end1 + end2 + end3 + end4 + end5 + end6,
print end7 + end8 + end9 + end10 + end11 + end12

print end1 + end2 + end3 + end4 + end5 + end6
print end7 + end8 + end9 + end10 + end11 + end12

# So it looks like you can use the trailing commas to join lines together?

var1 = 'This is a test...'
var2 = '...what just happened?'

print var1,
print var2

print "How about this way..."
print var1
print var2

print "Or this way.."
print var1, var2
print var1 + var2

# Output should look like this:
#
# Mary had a little lamb.
# Its fleece was white as snow.
# And everywhere that Mary went.
# ..........
# Cheese burger
# Cheese
# burger
# This is a test... ...what just happened?
# How about this way...
# This is a test...
# ...what just happened?
# Or this way..
# This is a test... ...what just happened?
# This is a test......what just happened?