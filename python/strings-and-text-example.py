# This example shows you how to work with crappy variables like x and y instead of something more human
# readable
#
# %s and %r do very similar things, but %r is typically used for debugging where as %s is
# for when you are outputting to users
x = 'There are %d types of people.' % 10
binary = 'binary'
do_not = 'don\'t' # note how the \ escape character was required so the ' in  don't was escaped
y = "Those who know %s and those who %s." % (binary, do_not)

print x
print y

print "I said: %r." % x
print "I also said: '%s'." % y

hilarious = False
joke_eval = "Isn't that joke so funny? %r."

print joke_eval % hilarious

w = "This is the left side of..."
e = "a string with a right side."

print w + e