require './test/mri_runner'

if Ractor.respond_to? :ractor_reset

  SKIP = [
    'touching moved object causes an error',
    'move example2: Array',
    'move with yield',
    'Access to global-variables are prohibited',
    '$stdin,out,err is Ractor local, but shared fds',
    'given block Proc will be isolated, so can not access outer variables.',
    'ivar in shareable-objects are not allowed to access from non-main Ractor',
    'cvar in shareable-objects are not allowed to access from non-main Ractor',
    'Getting non-shareable objects via constants by other Ractors is not allowed',
    'Setting non-shareable objects into constants by other Ractors is not allowed',
    'define_method is not allowed',
    'ObjectSpace.each_object can not handle unshareable objects with Ractors',
    'ObjectSpace._id2ref can not handle unshareable objects with Ractors',
    'ivar in shareable-objects are not allowed to access from non-main Ractor, by @iv (set)',
    'ivar in shareable-objects are not allowed to access from non-main Ractor, by @iv (get)',
    'Can not trap with not isolated Proc on non-main ractor',
    'Ractor.make_shareable(a_proc) makes a proc shareable',
    "define_method() can invoke different Ractor's proc if the proc is shareable.", # :-(
    'Ractor.make_shareable(a_proc) makes a proc shareable.',
    #*('Ractor.count' if RUBY_VERSION < '2.2')
  ].freeze

  alias show_progress_org show_progress
  def show_progress(m='', &b)
    _path, line = @location.split(':')
    comment = File.read(PATH).lines[line.to_i-2][2...-1]
    show_progress_org(m, &b) unless SKIP.include?(comment)
    Ractor.ractor_reset
  end

end
