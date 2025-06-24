module INotify
  module Native
    # A module containing all the inotify flags
    # to be passed to {Notifier#watch}.
    #
    # @private
    module Flags
      # File was accessed.
      IN_ACCESS = 0x00000001
      # Metadata changed.
      IN_ATTRIB = 0x00000004
      # Writtable file was closed.
      IN_CLOSE_WRITE = 0x00000008
      # Unwrittable file closed.
      IN_CLOSE_NOWRITE = 0x00000010
      # Subfile was created.
      IN_CREATE = 0x00000100
      # Subfile was deleted.
      IN_DELETE = 0x00000200
      # Self was deleted.
      IN_DELETE_SELF = 0x00000400
      # File was modified.
      IN_MODIFY = 0x00000002
      # Self was moved.
      IN_MOVE_SELF = 0x00000800
      # File was moved from X.
      IN_MOVED_FROM = 0x00000040
      # File was moved to Y.
      IN_MOVED_TO = 0x00000080
      # File was opened.
      IN_OPEN = 0x00000020

      ## Helper events.

      # Moves.
      IN_MOVE = (IN_MOVED_FROM | IN_MOVED_TO)
      # Close.
      IN_CLOSE = (IN_CLOSE_WRITE | IN_CLOSE_NOWRITE)
      # All events which a program can wait on.
      IN_ALL_EVENTS = (IN_ACCESS | IN_MODIFY | IN_ATTRIB | IN_CLOSE_WRITE |
        IN_CLOSE_NOWRITE | IN_OPEN | IN_MOVED_FROM | IN_MOVED_TO | IN_CREATE |
        IN_DELETE | IN_DELETE_SELF | IN_MOVE_SELF)


      ## Special flags.

      # Do not follow a sym link
      # available since Linux 2.6.15, causes EINVAL othervise
      IN_DONT_FOLLOW = 0x02000000
      # Exclude events on unlinked objects.
      # available since Linux 2.6.36, causes EINVAL othervise
      IN_EXCL_UNLINK = 0x04000000
      # Add to the mask of an already existing watch.
      IN_MASK_ADD = 0x20000000
      # Only send event once.
      IN_ONESHOT = 0x80000000
      # Only watch the path if it is a directory.
      # available since Linux 2.6.15, causes EINVAL othervise
      IN_ONLYDIR = 0x01000000
      # Only create watches.
      # available since Linux 4.18, causes EINVAL othervise
      IN_MASK_CREATE = 0x10000000

      ## Events sent by the kernel.

      # File was ignored.
      IN_IGNORED = 0x00008000
      # Event occurred against dir.
      IN_ISDIR = 0x40000000
      # Event queued overflowed.
      IN_Q_OVERFLOW = 0x00004000
      # Backing fs was unmounted.
      IN_UNMOUNT = 0x00002000

      EVENT_ONLY_FLAGS = IN_IGNORED | IN_ISDIR | IN_UNMOUNT | IN_Q_OVERFLOW

      ## fpathconf Macros

      # returns the maximum length of a filename in the directory path or fd that the process is allowed to create.  The corresponding macro is _POSIX_NAME_MAX.
      PC_NAME_MAX = 3

      # Converts a list of flags to the bitmask that the C API expects.
      #
      # @param flags [Array<Symbol>]
      # @return [Fixnum]
      def self.to_mask(flags)
        flags.map {|flag| to_add_watch_flag(flag) }.
          inject(0) {|mask, flag| mask | flag}
      end

      # Converts a flag to the value that can be used in inotify_add_watch
      #
      # @param flag [Symbol]
      # @return [Fixnum]
      # @raise [NameError] if the flag is not supported
      # @raise [ArgumentError] if the flag is defined, but can't be used in inotify_add_watch
      def self.to_add_watch_flag(flag)
        res = const_get("IN_#{flag.to_s.upcase}")
        raise ArgumentError, "Invalid flag: #{flag}" if EVENT_ONLY_FLAGS & res != 0

        res
      end

      # Converts a bitmask from the C API into a list of flags.
      #
      # @param mask [Fixnum]
      # @return [Array<Symbol>]
      def self.from_mask(mask)
        constants.map {|c| c.to_s}.select do |c|
          next false unless c =~ /^IN_/
          const_get(c) & mask != 0
        end.map {|c| c.sub("IN_", "").downcase.to_sym} - [:all_events]
      end
    end
  end
end
