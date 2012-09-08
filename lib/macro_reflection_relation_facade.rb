#This makes an ActiveRecord::Association look enough like a MacroReflection that
#it can stand in for one when making moderately complex activerecord queries that
#expect a normal Reflection, as would be returned by an ActiveRecord association.
class MacroReflectionRelationFacade < SimpleDelegator
  def target
    self
  end
end
