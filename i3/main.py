from i3ipc import Connection

# Create the Conncetion object that can be used to send commands and subscribe
# to events
i3 = Connection()

for leaf in i3.get_tree().scratchpad().leaves():
    print(leaf.__dict__)
    # print(leaf.name + ' || ' + leaf.window_class)

i3.command("""[title='Graduate Program | Department of Computer Science - Mozilla Firefox'] scratchpad show'""")
