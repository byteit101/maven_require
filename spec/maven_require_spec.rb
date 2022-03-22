# frozen_string_literal: true

RSpec.describe MavenRequire do
  it "has a version number" do
    expect(MavenRequire::VERSION).not_to be nil
  end

  it "requires with args, explicit version" do
    mr = maven_require 'net.openhft', 'zero-allocation-hashing', '0.15'
    expect(mr).not_to be nil
    expect(mr.first.coord).to eq "net.openhft:zero-allocation-hashing:jar:0.15"
    expect(Java::net.openhft.hashing.StringHash).not_to be nil
  end

  it "requires with coord, explicit version" do
    mr = maven_require 'com.github.houbb:hash-core:0.0.6'
    expect(mr).not_to be nil
    expect(mr.length).to be > 1
    expect(com.github.houbb.hash.core.core.code.HashCodeMurmur).not_to be nil
    # dependency
    expect(com.github.houbb.heaven.support.builder.IBuilder).not_to be nil
  end


  # fails with 3.3.9 maven, all old artifacts fail for some reason
  it "requires with block, latest version" do
    mr = maven_require do |dep|
      dep.jar 'antlr', 'antlr'
    end
    expect(mr).not_to be nil
    expect(Java::antlr::Grammar).not_to be nil
  end

  it "requires with block coord, latest version" do
    mr = maven_require do |dep|
      dep.jar 'javax.measure:jsr-275'
    end
    expect(mr).not_to be nil
    expect(mr.first.coord).to eq "javax.measure:jsr-275:jar:0.9.1"
    expect(javax.measure.Measure).not_to be nil
  end
end
