class NameDisplay
  def run(args, options)
    return display_name('') if options.delete

    return say('invalid customer name') if args.empty?

    display_name(args.join(' '))
  end

  def display_name(name)
    puts "TODO: display #{name}"
  end

  def delete_current
    display_name('')
  end
end
