from i3ipc import Connection

# Create the Conncetion object that can be used to send commands and subscribe
# to events
i3 = Connection()

for leaf in i3.get_tree().scratchpad().leaves():
    print(leaf.name + ' || ' + leaf.window_title)

i3.command("""[title='Synergy 1 Pro'] scratchpad show'""")
